open Core
open Command

let istr = Int.of_string
let fstr f = try Float.of_string f with _ -> 0.

let addr_to_int addr =
  let f i acc str =
    let num = istr str in
    let factor = Int.pow 256 (3 - i) in
    acc + (num * factor) in
  String.split addr ~on:'.'
  |> List.foldi ~init:0 ~f

let load_blocks path =
  let ic = In_channel.create path in
  ignore @@ In_channel.input_line ic; (* skip copyright notice of csv *)
  ignore @@ In_channel.input_line ic; (* skip format descriptor of csv *)
  Csv.load_in ic
  |> List.map
    ~f:(function
      | [start; stop; id] ->
        istr start, istr stop, istr id
      | _ -> failwith "invalid format: blocks")

let load_location path =
  let ic = In_channel.create path in
  ignore @@ In_channel.input_line ic; (* skip copyright notice of csv *)
  ignore @@ In_channel.input_line ic; (* skip format descriptor of csv *)
  Csv.load_in ic
  |> List.map
    ~f:(function
      | [id; country; region; city; zip; lat; lon; metro; area] ->
        istr id, country, region, city, zip, fstr lat, fstr lon, metro, area
      | _ -> failwith "invalid format: location")

let run blocks location addresses =
  List.iter
    addresses
    ~f:(fun address ->
      let addr = addr_to_int address in

      let rec loop = function
        | (start, stop, id) :: _ when addr >= start && addr < stop -> id
        | _ :: tl -> loop tl
        | [] -> failwith "ip address not found" in

      let rec loop2 loc query =
        match loc with
        | (id, country, region, city, zip, lat, lon, metro, area) :: _ when id = query ->
          Printf.printf "addr:%s lat:%f lon:%f\n" address lat lon
        | _ :: tl -> loop2 tl query
        | [] -> failwith "id not found" in

      loop blocks
      |> loop2 location)

let command =
  basic ~summary:"get coordinates for IP addresses"
    Spec.(
      empty
      +> anon ("blocks" %: file)
      +> anon ("location" %: file)
      +> anon (sequence ("address" %: string))
    ) (fun blocks_path location_path addresses () ->
        let blocks = load_blocks blocks_path in
        let location = load_location location_path in
        run blocks location addresses)

let () =
  let build_info =
    sprintf
      "OCaml version: %s\nExecution mode: %s\nOS type: %s\nExecutable: %s"
      Sys.ocaml_version
      (match Sys.execution_mode () with `Native -> "native" | `Bytecode -> "bytecode")
      Sys.os_type
      Sys.executable_name in
  Command.run ~version:"0.1.0" ~build_info command

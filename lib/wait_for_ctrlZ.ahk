wait_for_ctrlZ() {
    global equation
    transform, ctrlZ, chr, 26
    input, key_pressed, L1 M V T20
    if (key_pressed = ctrlZ)
        {
        clipboard("save")
        clipboard := equation
        clipboard("paste")
        clipboard("restore")
        }
}
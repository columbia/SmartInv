1 contract P4PState {
2     /** Stateless contract for persisting game states
3     @param states IPFS hashes (stripped of the type-length-value, see https://multiformats.io/multihash/)
4     of files containing raw game state data.
5     @param boards bitmap of the final gameboard state. Encoding:
6     0: unset, 1: black, 2: white. Which means 2 bit per field
7     Example: 3 fields black, white, unset encode to 1, 2, 0 => 0b011100
8     We have 9x9 = 81 fields. Thus 162 bit or 21 bytes (ceil(81 / 4)) are needed.
9     Remaining bits are set to 0.
10     */
11     function addGames(bytes32[] states, bytes32[] boards) {}
12 }
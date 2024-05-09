1 pragma solidity ^0.4.16;
2 
3 /* A small utility contract that sends ether to other addresses by means of 
4  * SUICIDE/SELFDESTRUCT. Unlike for a normal send/call, if the receiving address
5  * belongs to a contract, the contract's code is never called; one can
6  * forcibly increase a contract's balance!
7  *
8  * To send $x to y using this technique, simply call `suicideSend(y)` with a 
9  * value of $x.
10  *
11  *
12  * If you're interested in the implications of this trick, I recommend
13  * looking at João Carvalho's and Richard Moore's entries to the first
14  * Underhanded Solidity Contest [1]. Anybody writing smart ontracts should be 
15  * aware of forced balance increases lest their contracts be vulnerable.
16  * 
17  * [1] https://medium.com/@weka/announcing-the-winners-of-the-first-underhanded-solidity-coding-contest-282563a87079
18  */
19 contract SuicideSender {
20     function suicideSend(address to) payable {
21         address temp_addr;
22         assembly {
23             let free_ptr := mload(0x40)
24             /* Prepare initcode that immediately forwards any funds to address
25              * `to` by running [PUSH20 to, SUICIDE].
26              */
27             mstore(free_ptr, or(0x730000000000000000000000000000000000000000ff, mul(to, 0x100)))
28             // Run initcode we just prepared.
29             temp_addr := create(callvalue, add(free_ptr, 10), 22)
30         }
31         require(temp_addr != 0);
32     }
33 }
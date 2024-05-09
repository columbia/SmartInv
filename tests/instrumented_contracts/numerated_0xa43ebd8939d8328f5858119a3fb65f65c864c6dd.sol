1 pragma solidity ^0.4.4;
2 /*
3 * This is a contract for debloating the state
4 * @author mhswende
5 **/
6 contract Sweeper
7 {
8     //Solidity implentation
9     function sol_clean(uint256 s, uint i){
10         uint x = s;
11         address b = 0;
12         for(uint c=0 ; c < i ; c++){
13             x = x+s;
14             b = address(x/0x1000000000000000000000000);
15             b.send(0);
16 
17         }
18     }
19     //Asm implementation
20     function asm_clean(uint s, uint i)
21     {
22 
23         assembly{
24             let seed := calldataload(4)//4 if we're using a named function
25             let iterations := calldataload(36)
26             let target :=seed
27         
28         loop:
29             target := add(target,seed)
30             pop(call(0,div(target,0x1000000000000000000000000),0,0,0,0,0))
31             iterations := sub(iterations,1) 
32             jumpi(loop, iterations)
33         }
34     }
35 }
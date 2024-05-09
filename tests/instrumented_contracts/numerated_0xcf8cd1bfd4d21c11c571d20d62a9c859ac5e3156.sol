1 pragma solidity ^0.4.18;
2 
3 
4 contract Contract1 {
5 
6 	mapping (uint8 => mapping (address => bool)) public something;
7 
8 	function settrue(uint8 x, address a){
9 		something[x][a] = true;
10 	}
11 	function setfalse(uint8 x, address a){
12 		something[x][a] = false;
13 	}
14 }
15 
16 
17 
18 contract Contract2 {
19 
20     Contract1 public original;
21   
22   	mapping (uint16 => mapping (address => uint8)) public something;
23 
24     // コンストラクタ
25     function Contract2(address c) public {
26         original = Contract1(c);
27     }
28 
29 
30 	function test(uint8 x, address a){
31 		if(original.something(uint8(x),a))
32 			something[x][a] = 1;
33 		else
34 			something[x][a] = 2;
35 	}
36 }
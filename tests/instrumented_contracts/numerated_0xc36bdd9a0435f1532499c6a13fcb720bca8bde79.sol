1 pragma solidity ^0.4.17;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     /**
8      * Events
9      */
10     event ChangedOwner(address indexed new_owner);
11 
12     /**
13      * Functionality
14      */
15 
16     function Owned() {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function changeOwner(address _newOwner) onlyOwner external {
26         newOwner = _newOwner;
27     }
28 
29     function acceptOwnership() external {
30         if (msg.sender == newOwner) {
31             owner = newOwner;
32             newOwner = 0x0;
33             ChangedOwner(owner);
34         }
35     }
36 }
37 
38 contract IOwned {
39     function owner() returns (address);
40     function changeOwner(address);
41     function acceptOwnership();
42 }
43 
44 // interface with what we need to withdraw
45 contract Withdrawable {
46 	function withdrawTo(address) returns (bool);
47 }
48 
49 // responsible for 
50 contract Distributor is Owned {
51 
52 	uint256 public nonce;
53 	Withdrawable public w;
54 
55 	event BatchComplete(uint256 nonce);
56 
57 	event Complete();
58 
59 	function setWithdrawable(address w_addr) onlyOwner {
60 		w = Withdrawable(w_addr);
61 	}
62 	
63 	function distribute(address[] addrs) onlyOwner {
64 		for (uint256 i = 0; i <  addrs.length; i++) {
65 			w.withdrawTo(addrs[i]);
66 		}
67 		BatchComplete(nonce);
68 		nonce = nonce + 1;
69 	}
70 
71 	function complete() onlyOwner {
72 		nonce = 0;
73 		Complete();
74 	}
75 }
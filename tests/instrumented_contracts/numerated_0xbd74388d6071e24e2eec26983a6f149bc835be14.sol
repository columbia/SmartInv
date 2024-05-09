1 pragma solidity ^0.4.19;
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
38 // interface with what we need to withdraw
39 contract Withdrawable {
40 	function withdrawTo(address) returns (bool);
41 }
42 
43 // responsible for 
44 contract Distributor is Owned {
45 
46 	uint256 public nonce;
47 	Withdrawable public w;
48 
49 	event BatchComplete(uint256 nonce);
50 
51 	event Complete();
52 
53 	function setWithdrawable(address w_addr) onlyOwner {
54 		w = Withdrawable(w_addr);
55 	}
56 	
57 	function distribute(address[] addrs) onlyOwner {
58 		for (uint256 i = 0; i <  addrs.length; i++) {
59 			w.withdrawTo(addrs[i]);
60 		}
61 		BatchComplete(nonce);
62 		nonce = nonce + 1;
63 	}
64 
65 	function complete() onlyOwner {
66 		nonce = 0;
67 		Complete();
68 	}
69 }
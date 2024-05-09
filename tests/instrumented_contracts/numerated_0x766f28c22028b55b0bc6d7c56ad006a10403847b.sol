1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46 }
47 
48 
49 
50 
51 
52 
53 contract BuckySalary is Ownable {
54 
55     address[] public staff;
56     mapping(address => uint) public eth;
57 
58     
59     function BuckySalary() public {
60 
61     }
62 
63 
64     function getTotal() internal view returns (uint) {
65         uint total = 0;
66         for (uint i = 0; i < staff.length; i++) {
67             total += eth[staff[i]];    
68         }
69 
70         return total;
71     }
72 
73     event Transfer(address a, uint v);
74 
75     function () public payable {
76         uint total = getTotal();
77         require(msg.value >= total);
78 
79         for (uint i = 0; i < staff.length; i++) {
80             
81             address s = staff[i];
82             uint value = eth[s];
83             if (value > 0) {
84                 s.transfer(value);
85                 Transfer(s, value);
86             }
87         }
88 
89         if (msg.value > total) {
90             msg.sender.transfer(msg.value - total);
91         }
92     }
93 
94 
95     function setETH(address addr, uint value) public onlyOwner {
96         if (eth[addr] == 0) {
97             staff.push(addr);
98         }
99 
100         eth[addr] = value;
101     }
102 
103     function setMultiETH(address[] addr, uint[] value) public onlyOwner {
104         require(addr.length == value.length);
105         for (uint i = 0; i < addr.length; i++) {
106             setETH(addr[i], value[i]);
107         }
108     }
109 
110 }
1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 contract MultiOwnable {
35     mapping (address => bool) owners;
36     address unremovableOwner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39     event OwnershipExtended(address indexed host, address indexed guest);
40     event OwnershipRemoved(address indexed removedOwner);
41 
42     modifier onlyOwner() {
43         require(owners[msg.sender]);
44         _;
45     }
46 
47     constructor() public {
48         owners[msg.sender] = true;
49         unremovableOwner = msg.sender;
50     }
51 
52     function addOwner(address guest) onlyOwner public {
53         require(guest != address(0));
54         owners[guest] = true;
55         emit OwnershipExtended(msg.sender, guest);
56     }
57 
58     function removeOwner(address removedOwner) onlyOwner public {
59         require(removedOwner != address(0));
60         require(unremovableOwner != removedOwner);
61         delete owners[removedOwner];
62         emit OwnershipRemoved(removedOwner);
63     }
64 
65     function transferOwnership(address newOwner) onlyOwner public {
66         require(newOwner != address(0));
67         require(unremovableOwner != msg.sender);
68         owners[newOwner] = true;
69         delete owners[msg.sender];
70         emit OwnershipTransferred(msg.sender, newOwner);
71     }
72 
73     function isOwner(address addr) public view returns(bool){
74         return owners[addr];
75     }
76 }
77 
78 contract TokenLock is MultiOwnable {
79     ERC20 public token;
80     mapping (address => uint256) public lockAmounts;
81     mapping (address => uint256) public releaseTimestamps;
82 
83     constructor (address _token) public {
84         token = ERC20(_token);
85     }
86 
87     function getLockAmount(address _addr) external view returns (uint256) {
88         return lockAmounts[_addr];
89     }
90 
91     function getReleaseBlock(address _addr) external view returns (uint256) {
92         return releaseTimestamps[_addr];
93     }
94 
95     function lock(address _addr, uint256 _amount, uint256 _releaseTimestamp) external {
96         require(owners[msg.sender]);
97         require(_addr != address(0));
98         lockAmounts[_addr] = _amount;
99         releaseTimestamps[_addr] = _releaseTimestamp;
100     }
101 
102     function release(address _addr) external {
103         require(owners[msg.sender] || msg.sender == _addr);
104         require(block.timestamp >= releaseTimestamps[_addr]);
105         uint256 amount = lockAmounts[_addr];
106         lockAmounts[_addr] = 0;
107         releaseTimestamps[_addr] = 0;
108         token.transfer(_addr, amount);
109     }
110 }
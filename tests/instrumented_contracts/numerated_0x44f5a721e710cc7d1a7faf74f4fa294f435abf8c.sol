1 pragma solidity ^0.4.23;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract WhiteListedBasic {
6     function addWhiteListed(address[] addrs) external;
7     function removeWhiteListed(address addr) external;
8     function isWhiteListed(address addr) external view returns (bool);
9 }
10 contract OperatableBasic {
11     function setMinter (address addr) external;
12     function setWhiteLister (address addr) external;
13 }
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipRenounced(address indexed previousOwner);
19   event OwnershipTransferred(
20     address indexed previousOwner,
21     address indexed newOwner
22   );
23 
24 
25   /**
26    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27    * account.
28    */
29   constructor() public {
30     owner = msg.sender;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0));
47     emit OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51   /**
52    * @dev Allows the current owner to relinquish control of the contract.
53    */
54   function renounceOwnership() public onlyOwner {
55     emit OwnershipRenounced(owner);
56     owner = address(0);
57   }
58 }
59 
60 contract Claimable is Ownable {
61   address public pendingOwner;
62 
63   /**
64    * @dev Modifier throws if called by any account other than the pendingOwner.
65    */
66   modifier onlyPendingOwner() {
67     require(msg.sender == pendingOwner);
68     _;
69   }
70 
71   /**
72    * @dev Allows the current owner to set the pendingOwner address.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) onlyOwner public {
76     pendingOwner = newOwner;
77   }
78 
79   /**
80    * @dev Allows the pendingOwner address to finalize the transfer.
81    */
82   function claimOwnership() onlyPendingOwner public {
83     emit OwnershipTransferred(owner, pendingOwner);
84     owner = pendingOwner;
85     pendingOwner = address(0);
86   }
87 }
88 
89 contract Operatable is Claimable, OperatableBasic {
90     address public minter;
91     address public whiteLister;
92     address public launcher;
93 
94     event NewMinter(address newMinter);
95     event NewWhiteLister(address newwhiteLister);
96 
97     modifier canOperate() {
98         require(msg.sender == minter || msg.sender == whiteLister || msg.sender == owner);
99         _;
100     }
101 
102     constructor() public {
103         minter = owner;
104         whiteLister = owner;
105         launcher = owner;
106     }
107 
108     function setMinter (address addr) external onlyOwner {
109         minter = addr;
110         emit NewMinter(minter);
111     }
112 
113     function setWhiteLister (address addr) external onlyOwner {
114         whiteLister = addr;
115         emit NewWhiteLister(whiteLister);
116     }
117 
118     modifier ownerOrMinter()  {
119         require ((msg.sender == minter) || (msg.sender == owner));
120         _;
121     }
122 
123     modifier onlyLauncher()  {
124         require (msg.sender == launcher);
125         _;
126     }
127 
128     modifier onlyWhiteLister()  {
129         require (msg.sender == whiteLister);
130         _;
131     }
132 }
133 contract WhiteListed is Operatable, WhiteListedBasic {
134 
135 
136     uint public count;
137     mapping (address => bool) public whiteList;
138 
139     event Whitelisted(address indexed addr, uint whitelistedCount, bool isWhitelisted);
140 
141     function addWhiteListed(address[] addrs) external canOperate {
142         uint c = count;
143         for (uint i = 0; i < addrs.length; i++) {
144             if (!whiteList[addrs[i]]) {
145                 whiteList[addrs[i]] = true;
146                 c++;
147                 emit Whitelisted(addrs[i], count, true);
148             }
149         }
150         count = c;
151     }
152 
153     function removeWhiteListed(address addr) external canOperate {
154         require(whiteList[addr]);
155         whiteList[addr] = false;
156         count--;
157         emit Whitelisted(addr, count, false);
158     }
159 
160     function isWhiteListed(address addr) external view returns (bool) {
161         return whiteList[addr];
162     }
163 }
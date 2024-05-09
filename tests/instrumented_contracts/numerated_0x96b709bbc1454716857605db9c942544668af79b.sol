1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     emit OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 contract Autonomy is Ownable {
39     address public congress;
40     bool init = false;
41 
42     modifier onlyCongress() {
43         require(msg.sender == congress);
44         _;
45     }
46 
47     /**
48      * @dev initialize a Congress contract address for this token 
49      *
50      * @param _congress address the congress contract address
51      */
52     function initialCongress(address _congress) onlyOwner public {
53         require(!init);
54         require(_congress != address(0));
55         congress = _congress;
56         init = true;
57     }
58 
59     /**
60      * @dev set a Congress contract address for this token
61      * must change this address by the last congress contract 
62      *
63      * @param _congress address the congress contract address
64      */
65     function changeCongress(address _congress) onlyCongress public {
66         require(_congress != address(0));
67         congress = _congress;
68     }
69 }
70 
71 contract Destructible is Ownable {
72 
73   function Destructible() public payable { }
74 
75   /**
76    * @dev Transfers the current balance to the owner and terminates the contract.
77    */
78   function destroy() onlyOwner public {
79     selfdestruct(owner);
80   }
81 
82   function destroyAndSend(address _recipient) onlyOwner public {
83     selfdestruct(_recipient);
84   }
85 }
86 
87 contract Claimable is Ownable {
88   address public pendingOwner;
89 
90   /**
91    * @dev Modifier throws if called by any account other than the pendingOwner.
92    */
93   modifier onlyPendingOwner() {
94     require(msg.sender == pendingOwner);
95     _;
96   }
97 
98   /**
99    * @dev Allows the current owner to set the pendingOwner address.
100    * @param newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address newOwner) onlyOwner public {
103     pendingOwner = newOwner;
104   }
105 
106   /**
107    * @dev Allows the pendingOwner address to finalize the transfer.
108    */
109   function claimOwnership() onlyPendingOwner public {
110     emit OwnershipTransferred(owner, pendingOwner);
111     owner = pendingOwner;
112     pendingOwner = address(0);
113   }
114 }
115 
116 contract DRCWalletMgrParams is Claimable, Autonomy, Destructible {
117     uint256 public singleWithdraw; // Max value of single withdraw
118     uint256 public dayWithdraw; // Max value of one day of withdraw
119     uint256 public monthWithdraw; // Max value of one month of withdraw
120     uint256 public dayWithdrawCount; // Max number of withdraw counting
121 
122     uint256 public chargeFee; // the charge fee for withdraw
123     address public chargeFeePool; // the address that will get the returned charge fees.
124 
125 
126     function initialSingleWithdraw(uint256 _value) onlyOwner public {
127         require(!init);
128 
129         singleWithdraw = _value;
130     }
131 
132     function initialDayWithdraw(uint256 _value) onlyOwner public {
133         require(!init);
134 
135         dayWithdraw = _value;
136     }
137 
138     function initialDayWithdrawCount(uint256 _count) onlyOwner public {
139         require(!init);
140 
141         dayWithdrawCount = _count;
142     }
143 
144     function initialMonthWithdraw(uint256 _value) onlyOwner public {
145         require(!init);
146 
147         monthWithdraw = _value;
148     }
149 
150     function initialChargeFee(uint256 _value) onlyOwner public {
151         require(!init);
152 
153         singleWithdraw = _value;
154     }
155 
156     function initialChargeFeePool(address _pool) onlyOwner public {
157         require(!init);
158 
159         chargeFeePool = _pool;
160     }    
161 
162     function setSingleWithdraw(uint256 _value) onlyCongress public {
163         singleWithdraw = _value;
164     }
165 
166     function setDayWithdraw(uint256 _value) onlyCongress public {
167         dayWithdraw = _value;
168     }
169 
170     function setDayWithdrawCount(uint256 _count) onlyCongress public {
171         dayWithdrawCount = _count;
172     }
173 
174     function setMonthWithdraw(uint256 _value) onlyCongress public {
175         monthWithdraw = _value;
176     }
177 
178     function setChargeFee(uint256 _value) onlyCongress public {
179         singleWithdraw = _value;
180     }
181 
182     function setChargeFeePool(address _pool) onlyOwner public {
183         chargeFeePool = _pool;
184     }
185 }
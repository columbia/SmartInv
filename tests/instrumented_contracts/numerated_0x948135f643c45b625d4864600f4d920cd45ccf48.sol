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
117     uint256 public singleWithdrawMin; // min value of single withdraw
118     uint256 public singleWithdrawMax; // Max value of single withdraw
119     uint256 public dayWithdraw; // Max value of one day of withdraw
120     uint256 public monthWithdraw; // Max value of one month of withdraw
121     uint256 public dayWithdrawCount; // Max number of withdraw counting
122 
123     uint256 public chargeFee; // the charge fee for withdraw
124     address public chargeFeePool; // the address that will get the returned charge fees.
125 
126 
127     function initialSingleWithdrawMax(uint256 _value) onlyOwner public {
128         require(!init);
129 
130         singleWithdrawMax = _value;
131     }
132 
133     function initialSingleWithdrawMin(uint256 _value) onlyOwner public {
134         require(!init);
135 
136         singleWithdrawMin = _value;
137     }
138 
139     function initialDayWithdraw(uint256 _value) onlyOwner public {
140         require(!init);
141 
142         dayWithdraw = _value;
143     }
144 
145     function initialDayWithdrawCount(uint256 _count) onlyOwner public {
146         require(!init);
147 
148         dayWithdrawCount = _count;
149     }
150 
151     function initialMonthWithdraw(uint256 _value) onlyOwner public {
152         require(!init);
153 
154         monthWithdraw = _value;
155     }
156 
157     function initialChargeFee(uint256 _value) onlyOwner public {
158         require(!init);
159 
160         chargeFee = _value;
161     }
162 
163     function initialChargeFeePool(address _pool) onlyOwner public {
164         require(!init);
165 
166         chargeFeePool = _pool;
167     }    
168 
169     function setSingleWithdrawMax(uint256 _value) onlyCongress public {
170         singleWithdrawMax = _value;
171     }   
172 
173     function setSingleWithdrawMin(uint256 _value) onlyCongress public {
174         singleWithdrawMin = _value;
175     }
176 
177     function setDayWithdraw(uint256 _value) onlyCongress public {
178         dayWithdraw = _value;
179     }
180 
181     function setDayWithdrawCount(uint256 _count) onlyCongress public {
182         dayWithdrawCount = _count;
183     }
184 
185     function setMonthWithdraw(uint256 _value) onlyCongress public {
186         monthWithdraw = _value;
187     }
188 
189     function setChargeFee(uint256 _value) onlyCongress public {
190         chargeFee = _value;
191     }
192 
193     function setChargeFeePool(address _pool) onlyCongress public {
194         chargeFeePool = _pool;
195     }
196 }
1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    */
33   function renounceOwnership() public onlyOwner {
34     emit OwnershipRenounced(owner);
35     owner = address(0);
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param _newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address _newOwner) public onlyOwner {
43     _transferOwnership(_newOwner);
44   }
45 
46   /**
47    * @dev Transfers control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function _transferOwnership(address _newOwner) internal {
51     require(_newOwner != address(0));
52     emit OwnershipTransferred(owner, _newOwner);
53     owner = _newOwner;
54   }
55 }
56 
57 contract Autonomy is Ownable {
58     address public congress;
59     bool init = false;
60 
61     modifier onlyCongress() {
62         require(msg.sender == congress);
63         _;
64     }
65 
66     /**
67      * @dev initialize a Congress contract address for this token
68      *
69      * @param _congress address the congress contract address
70      */
71     function initialCongress(address _congress) onlyOwner public {
72         require(!init);
73         require(_congress != address(0));
74         congress = _congress;
75         init = true;
76     }
77 
78     /**
79      * @dev set a Congress contract address for this token
80      * must change this address by the last congress contract
81      *
82      * @param _congress address the congress contract address
83      */
84     function changeCongress(address _congress) onlyCongress public {
85         require(_congress != address(0));
86         congress = _congress;
87     }
88 }
89 
90 contract Destructible is Ownable {
91 
92   constructor() public payable { }
93 
94   /**
95    * @dev Transfers the current balance to the owner and terminates the contract.
96    */
97   function destroy() onlyOwner public {
98     selfdestruct(owner);
99   }
100 
101   function destroyAndSend(address _recipient) onlyOwner public {
102     selfdestruct(_recipient);
103   }
104 }
105 
106 contract Claimable is Ownable {
107   address public pendingOwner;
108 
109   /**
110    * @dev Modifier throws if called by any account other than the pendingOwner.
111    */
112   modifier onlyPendingOwner() {
113     require(msg.sender == pendingOwner);
114     _;
115   }
116 
117   /**
118    * @dev Allows the current owner to set the pendingOwner address.
119    * @param newOwner The address to transfer ownership to.
120    */
121   function transferOwnership(address newOwner) onlyOwner public {
122     pendingOwner = newOwner;
123   }
124 
125   /**
126    * @dev Allows the pendingOwner address to finalize the transfer.
127    */
128   function claimOwnership() onlyPendingOwner public {
129     emit OwnershipTransferred(owner, pendingOwner);
130     owner = pendingOwner;
131     pendingOwner = address(0);
132   }
133 }
134 
135 contract DRCWalletMgrParams is Claimable, Autonomy, Destructible {
136     uint256 public singleWithdrawMin; // min value of single withdraw
137     uint256 public singleWithdrawMax; // Max value of single withdraw
138     uint256 public dayWithdraw; // Max value of one day of withdraw
139     uint256 public monthWithdraw; // Max value of one month of withdraw
140     uint256 public dayWithdrawCount; // Max number of withdraw counting
141 
142     uint256 public chargeFee; // the charge fee for withdraw
143     address public chargeFeePool; // the address that will get the returned charge fees.
144 
145 
146     function initialSingleWithdrawMax(uint256 _value) onlyOwner public {
147         require(!init);
148 
149         singleWithdrawMax = _value;
150     }
151 
152     function initialSingleWithdrawMin(uint256 _value) onlyOwner public {
153         require(!init);
154 
155         singleWithdrawMin = _value;
156     }
157 
158     function initialDayWithdraw(uint256 _value) onlyOwner public {
159         require(!init);
160 
161         dayWithdraw = _value;
162     }
163 
164     function initialDayWithdrawCount(uint256 _count) onlyOwner public {
165         require(!init);
166 
167         dayWithdrawCount = _count;
168     }
169 
170     function initialMonthWithdraw(uint256 _value) onlyOwner public {
171         require(!init);
172 
173         monthWithdraw = _value;
174     }
175 
176     function initialChargeFee(uint256 _value) onlyOwner public {
177         require(!init);
178 
179         chargeFee = _value;
180     }
181 
182     function initialChargeFeePool(address _pool) onlyOwner public {
183         require(!init);
184 
185         chargeFeePool = _pool;
186     }
187 
188     function setSingleWithdrawMax(uint256 _value) onlyCongress public {
189         singleWithdrawMax = _value;
190     }
191 
192     function setSingleWithdrawMin(uint256 _value) onlyCongress public {
193         singleWithdrawMin = _value;
194     }
195 
196     function setDayWithdraw(uint256 _value) onlyCongress public {
197         dayWithdraw = _value;
198     }
199 
200     function setDayWithdrawCount(uint256 _count) onlyCongress public {
201         dayWithdrawCount = _count;
202     }
203 
204     function setMonthWithdraw(uint256 _value) onlyCongress public {
205         monthWithdraw = _value;
206     }
207 
208     function setChargeFee(uint256 _value) onlyCongress public {
209         chargeFee = _value;
210     }
211 
212     function setChargeFeePool(address _pool) onlyCongress public {
213         chargeFeePool = _pool;
214     }
215 }
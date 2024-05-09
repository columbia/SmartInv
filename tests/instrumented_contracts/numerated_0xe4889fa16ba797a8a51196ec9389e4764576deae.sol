1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title Pausable
48  * @dev Base contract which allows children to implement an emergency stop mechanism.
49  */
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53 
54   bool public paused = false;
55 
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is not paused.
59    */
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is paused.
67    */
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   /**
74    * @dev called by the owner to pause, triggers stopped state
75    */
76   function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     emit Pause();
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused public {
85     paused = false;
86     emit Unpause();
87   }
88 }
89 
90 
91 /// @title BlockchainCuties Presale
92 contract BlockchainCutiesPresale is Pausable
93 {
94     struct Purchase
95     {
96         address owner;
97         uint32 cutieKind;
98         uint128 price;
99     }
100     Purchase[] public purchases;
101 
102     struct Cutie
103     {
104         uint128 price;
105         uint128 leftCount;
106         uint128 priceMul;
107         uint128 priceAdd;
108     }
109 
110     mapping (uint32 => Cutie) public cutie;
111 
112     event Bid(uint256 indexed purchaseId);
113 
114     function addCutie(uint32 id, uint128 price, uint128 count, uint128 priceMul, uint128 priceAdd) public onlyOwner
115     {
116         cutie[id] = Cutie(price, count, priceMul, priceAdd);
117     }
118 
119     function isAvailable(uint32 cutieKind) public view returns (bool)
120     {
121         return cutie[cutieKind].leftCount > 0;
122     }
123 
124     function getPrice(uint32 cutieKind) public view returns (uint256 price, uint256 left)
125     {
126         price = cutie[cutieKind].price;
127         left = cutie[cutieKind].leftCount;
128     }
129 
130     function bid(uint32 cutieKind) public payable whenNotPaused
131     {
132         Cutie storage p = cutie[cutieKind];
133         require(isAvailable(cutieKind));
134         require(p.price <= msg.value);
135 
136         uint256 length = purchases.push(Purchase(msg.sender, cutieKind, uint128(msg.value)));
137 
138         emit Bid(length - 1);
139 
140         p.leftCount--;
141         p.price = uint128(uint256(p.price)*p.priceMul / 1000000000000000000 + p.priceAdd);
142     }
143 
144     function purchasesCount() public view returns (uint256)
145     {
146         return purchases.length;
147     }
148 
149     function destroyContract() public onlyOwner {
150         require(address(this).balance == 0);
151         selfdestruct(msg.sender);
152     }
153 
154     address party1address;
155     address party2address;
156     address party3address;
157     address party4address;
158     address party5address;
159 
160     /// @dev Setup project owners
161     function setParties(address _party1, address _party2, address _party3, address _party4, address _party5) public onlyOwner
162     {
163         require(_party1 != address(0));
164         require(_party2 != address(0));
165         require(_party3 != address(0));
166         require(_party4 != address(0));
167         require(_party5 != address(0));
168 
169         party1address = _party1;
170         party2address = _party2;
171         party3address = _party3;
172         party4address = _party4;
173         party5address = _party5;
174     }
175 
176     /// @dev Reject all Ether
177     function() external payable {
178         revert();
179     }
180 
181     /// @dev The balance transfer to project owners
182     function withdrawEthFromBalance() external
183     {
184         require(
185             msg.sender == party1address ||
186             msg.sender == party2address ||
187             msg.sender == party3address ||
188             msg.sender == party4address ||
189             msg.sender == party5address ||
190             msg.sender == owner);
191 
192         require(party1address != 0);
193         require(party2address != 0);
194         require(party3address != 0);
195         require(party4address != 0);
196         require(party5address != 0);
197 
198         uint256 total = address(this).balance;
199 
200         party1address.transfer(total*105/1000);
201         party2address.transfer(total*105/1000);
202         party3address.transfer(total*140/1000);
203         party4address.transfer(total*140/1000);
204         party5address.transfer(total*510/1000);
205     }    
206 }
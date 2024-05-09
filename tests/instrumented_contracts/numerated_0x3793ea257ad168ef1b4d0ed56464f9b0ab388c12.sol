1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title CryptoEmojis
5  * @author CryptoEmojis
6  */
7 contract CryptoEmojis {
8     // Using SafeMath
9     using SafeMath for uint256;    
10 
11     // The developer's address
12     address dev;
13 
14     // Contract information
15     string constant private tokenName = "CryptoEmojis";
16     string constant private tokenSymbol = "EMO";
17 
18     // Our beloved emojis
19     struct Emoji {
20         string codepoints;
21         string name;
22         uint256 price;
23         address owner;
24         bool exists;
25     }
26 
27     Emoji[] emojis;
28     
29     // For storing the username and balance of every user
30     mapping(address => uint256) private balances;
31     mapping(address => bytes16) private usernames;
32 
33     // Needed events for represententing of every possible action
34     event Transfer(address indexed _from, address indexed _to, uint256 indexed _id, uint256 _price);
35     event PriceChange(uint256 indexed _id, uint256 _price);
36     event UsernameChange(address indexed _owner, bytes16 _username);
37 
38 
39     function CryptoEmojis() public {
40         dev = msg.sender;
41     }
42     
43     
44     modifier onlyDev() {
45         require(msg.sender == dev);
46         _;
47     }
48 
49    function name() public pure returns(string) {
50        return tokenName;
51    }
52 
53    function symbol() public pure returns(string) {
54        return tokenSymbol;
55    }
56 
57     /** @dev Get the total supply */
58     function totalSupply() public view returns(uint256) {
59         return emojis.length;
60     }
61 
62     /** @dev Get the balance of a user */
63    function balanceOf(address _owner) public view returns(uint256 balance) {
64        return balances[_owner];
65    }
66 
67     /** @dev Get the username of a user */
68     function usernameOf(address _owner) public view returns (bytes16) {
69        return usernames[_owner];
70     }
71     
72     /** @dev Set the username of sender user  */
73     function setUsername(bytes16 _username) public {
74         usernames[msg.sender] = _username;
75         emit UsernameChange(msg.sender, _username);
76     }
77 
78     /** @dev Get the owner of an emoji */
79     function ownerOf(uint256 _id) public constant returns (address) {
80        return emojis[_id].owner;
81     }
82     
83     /** @dev Get the codepoints of an emoji */
84     function codepointsOf(uint256 _id) public view returns (string) {
85        return emojis[_id].codepoints;
86     }
87 
88     /** @dev Get the name of an emoji */
89     function nameOf(uint256 _id) public view returns (string) {
90        return emojis[_id].name;
91     }
92 
93     /** @dev Get the price of an emoji */
94     function priceOf(uint256 _id) public view returns (uint256 price) {
95        return emojis[_id].price;
96     }
97 
98     /** @dev Ceate a new emoji for the first time */
99     function create(string _codepoints, string _name, uint256 _price) public onlyDev() {
100         Emoji memory _emoji = Emoji({
101             codepoints: _codepoints,
102             name: _name,
103             price: _price,
104             owner: dev,
105             exists: true
106         });
107         emojis.push(_emoji);
108         balances[dev]++;
109     }
110 
111     /** @dev Edit emoji information to maintain confirming for Unicode standard, we can't change the price or the owner */
112     function edit(uint256 _id, string _codepoints, string _name) public onlyDev() {
113         require(emojis[_id].exists);
114         emojis[_id].codepoints = _codepoints;
115         emojis[_id].name = _name;
116     }
117 
118     /** @dev Buy an emoji */
119     function buy(uint256 _id) payable public {
120         require(emojis[_id].exists && emojis[_id].owner != msg.sender && msg.value >= emojis[_id].price);
121         address oldOwner = emojis[_id].owner;
122         uint256 oldPrice = emojis[_id].price;
123         emojis[_id].owner = msg.sender;
124         emojis[_id].price = oldPrice.div(100).mul(115);
125         balances[oldOwner]--;
126         balances[msg.sender]++;
127         oldOwner.transfer(oldPrice.div(100).mul(96));
128         if (msg.value > oldPrice) msg.sender.transfer(msg.value.sub(oldPrice));
129         emit Transfer(oldOwner, msg.sender, _id, oldPrice);
130         emit PriceChange(_id, emojis[_id].price);
131     }
132 
133     /** @dev Changing the price by the owner of the emoji */
134     function setPrice(uint256 _id, uint256 _price) public {
135         require(emojis[_id].exists && emojis[_id].owner == msg.sender);
136         emojis[_id].price =_price;
137         emit PriceChange(_id, _price);
138     }
139 
140     /** @dev Withdraw all balance. This doesn't transfer users' money since the contract pay them instantly and doesn't hold anyone's money */
141     function withdraw() public onlyDev() {
142         dev.transfer(address(this).balance);
143     }
144 }
145 
146 /**
147  * @title SafeMath
148  * @dev Math operations with safety checks that throw on error
149  */
150 library SafeMath {
151   /**
152   * @dev Multiplies two numbers, throws on overflow.
153   */
154   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155     if (a == 0) {
156       return 0;
157     }
158     uint256 c = a * b;
159     assert(c / a == b);
160     return c;
161   }
162 
163   /**
164   * @dev Integer division of two numbers, truncating the quotient.
165   */
166   function div(uint256 a, uint256 b) internal pure returns (uint256) {
167     // assert(b > 0); // Solidity automatically throws when dividing by 0
168     uint256 c = a / b;
169     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170     return c;
171   }
172 
173   /**
174   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
175   */
176   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177     assert(b <= a);
178     return a - b;
179   }
180 }
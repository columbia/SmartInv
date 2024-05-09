1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30      * @dev Allows the current owner to transfer control of the contract to a newOwner.
31      * @param _newOwner The address to transfer ownership to.
32      */
33     function transferOwnership(address _newOwner) public onlyOwner {
34         require(_newOwner != address(0));
35         emit OwnershipTransferred(owner, _newOwner);
36         owner = _newOwner;
37     }
38 }
39 
40 /*
41   BASIC ERC20 Sale Contract
42   @author Hunter Long
43   @repo https://github.com/hunterlong/ethereum-ico-contract
44   (c) SCU GmbH 2018. The MIT Licence.
45 */
46 contract SCUTokenCrowdsale is Ownable {
47 
48     uint256 public totalSold; //eurocents
49 
50     FiatContract public fiat;
51     ERC20 public Token;
52     address public ETHWallet;
53     Whitelist public white;
54 
55     uint256 public tokenSold;
56     uint256 public tokenPrice;
57 
58     uint256 public deadline;
59     uint256 public start;
60 
61     bool public crowdsaleClosed;
62 
63     event Contribution(address from, uint256 amount);
64 
65     constructor() public {
66         ETHWallet = 0x78D97495f7CA56aC3956E847BB75F825834575A4;
67         Token = ERC20(0xBD82A3C93B825c1F93202F9Dd0a120793E029BAD);
68         crowdsaleClosed = false;
69         white = Whitelist(0xc0b11003708F9d8896c7676fD129188041B7F60B);
70         tokenSold = 0; // per contract
71         tokenPrice = 20; // eurocents
72         fiat = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
73         //https://ethereum.stackexchange.com/questions/34110/compare-dates-in-solidity
74         start = now;
75         deadline = now + 80 * 1 days;
76     }
77 
78     function () public payable {
79         require(msg.value>0);
80         require(white.isWhitelisted(msg.sender) == true);
81         require(!crowdsaleClosed);
82         require(now <= deadline && now >= start);
83         //https://ethereum.stackexchange.com/questions/9256/float-not-allowed-in-solidity-vs-decimal-places-asked-for-token-contract
84         //fee falls away
85 
86         uint256 amount = (msg.value / getTokenPrice()) * 1 ether;
87         totalSold += (amount / tokenPrice) * 100;
88 
89         //afterwards calculate  pre sale bonusprogramm
90         if(tokenSold < 6000000)
91         {
92         amount = amount + ((amount * 25) / 100);
93         }
94         else if(tokenSold < 12000000)
95         {
96         amount = amount + ((amount * 15) / 100);
97         }
98         else
99         {
100         amount = amount + ((amount * 10) / 100);
101         }
102 
103         ETHWallet.transfer(msg.value);
104         Token.transferFrom(owner, msg.sender, amount);
105         emit Contribution(msg.sender, amount);
106     }
107 
108     function getTokenPrice() internal view returns (uint256) {
109         return getEtherInEuroCents() * tokenPrice / 100;
110     }
111 
112     function getEtherInEuroCents() internal view returns (uint256) {
113         return fiat.EUR(0) * 100;
114     }
115 
116     function closeCrowdsale() public onlyOwner returns (bool) {
117         crowdsaleClosed = true;
118         return true;
119     }
120 }
121 
122 contract Whitelist {
123     function isWhitelisted(address _account) public constant returns (bool);
124 
125 }
126 
127 contract ERC20 {
128     uint public totalSupply;
129     function balanceOf(address who) public constant returns (uint);
130     function allowance(address owner, address spender) public constant returns (uint);
131     function transfer(address to, uint value) public returns (bool ok);
132     function transferFrom(address from, address to, uint value) public returns (bool ok);
133     function approve(address spender, uint value) public returns (bool ok);
134     function mint(address to, uint256 value) public returns (uint256);
135 }
136 
137 contract FiatContract {
138     function ETH(uint _id) public view returns (uint256);
139     function USD(uint _id) public view returns (uint256);
140     function EUR(uint _id) public view returns (uint256);
141     function GBP(uint _id) public view returns (uint256);
142     function updatedAt(uint _id) public view returns (uint);
143 }
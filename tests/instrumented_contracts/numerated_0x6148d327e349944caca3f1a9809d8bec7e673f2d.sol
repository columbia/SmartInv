1 /**
2  *Submitted for verification at Etherscan.io on 2018-03-16
3 */
4 
5 pragma solidity ^0.5.8;
6 
7 /**
8  * Library to handle user permissions.
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18     /** @dev The Ownable constructor sets the original `owner` of the contract to the sender account. */
19     constructor()
20         internal
21     {
22         _owner = msg.sender;
23         emit OwnershipTransferred(address(0), _owner);
24     }
25 
26     /** @return the address of the owner. */
27     function owner()
28         public
29         view
30         returns(address)
31     {
32         return _owner;
33     }
34 
35     /** @dev Throws if called by any account other than the owner. */
36     modifier onlyOwner() {
37         require(isOwner(), "NOT_OWNER");
38         _;
39     }
40 
41     /** @return true if `msg.sender` is the owner of the contract. */
42     function isOwner()
43         public
44         view
45         returns(bool)
46     {
47         return msg.sender == _owner;
48     }
49 
50     /** @dev Allows the current owner to relinquish control of the contract.
51      * @notice Renouncing to ownership will leave the contract without an owner.
52      * It will not be possible to call the functions with the `onlyOwner`
53      * modifier anymore.
54      */
55     function renounceOwnership()
56         public
57         onlyOwner
58     {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 
63     /** @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(
67         address newOwner
68     )
69         public
70         onlyOwner
71     {
72         require(newOwner != address(0), "INVALID_OWNER");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 contract Eth2daiInterface {
79     // sellAllAmount(ERC20 pay_gem, uint pay_amt, ERC20 buy_gem, uint min_fill_amount)
80     function sellAllAmount(address, uint, address, uint) public returns (uint);
81 }
82 
83 contract TokenInterface {
84     function balanceOf(address) public returns (uint);
85     function allowance(address, address) public returns (uint);
86     function approve(address, uint) public;
87     function transfer(address,uint) public returns (bool);
88     function transferFrom(address, address, uint) public returns (bool);
89     function deposit() public payable;
90     function withdraw(uint) public;
91 }
92 
93 contract Eth2daiDirect is Ownable {
94 
95     Eth2daiInterface public constant eth2dai = Eth2daiInterface(0x39755357759cE0d7f32dC8dC45414CCa409AE24e);
96     TokenInterface public constant wethToken = TokenInterface(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
97     TokenInterface public constant daiToken = TokenInterface(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
98 
99     constructor()
100         public
101     {
102         daiToken.approve(address(eth2dai), 2**256-1);
103         wethToken.approve(address(eth2dai), 2**256-1);
104     }
105 
106     function marketBuyEth(
107         uint256 payDaiAmount,
108         uint256 minBuyEthAmount
109     )
110         public
111     {
112         daiToken.transferFrom(msg.sender, address(this), payDaiAmount);
113         uint256 fillAmount = eth2dai.sellAllAmount(address(daiToken), payDaiAmount, address(wethToken), minBuyEthAmount);
114         wethToken.withdraw(fillAmount);
115         msg.sender.transfer(fillAmount);
116     }
117 
118     function marketSellEth(
119         uint256 payEthAmount,
120         uint256 minBuyDaiAmount
121     )
122         public
123         payable
124     {
125         require(msg.value == payEthAmount, "MSG_VALUE_NOT_MATCH");
126         wethToken.deposit.value(msg.value)();
127         uint256 fillAmount = eth2dai.sellAllAmount(address(wethToken), payEthAmount, address(daiToken), minBuyDaiAmount);
128         daiToken.transfer(msg.sender, fillAmount);
129     }
130 
131     function withdraw(
132         address tokenAddress,
133         uint256 amount
134     )
135         public
136         onlyOwner
137     {
138         if (tokenAddress == address(0)) {
139             msg.sender.transfer(amount);
140         } else {
141             TokenInterface(tokenAddress).transfer(msg.sender, amount);
142         }
143     }
144 
145     function() external payable {
146         require(msg.sender == address(wethToken), "CONTRACT_NOT_PAYABLE");
147     }
148 }
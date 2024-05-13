1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 
4 import "@openzeppelin/contracts/access/Ownable.sol";
5 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
6 
7 import "../interfaces/ITokenLockVestReader.sol";
8 
9 /**
10  * @dev Sells a token at a predetermined price to whitelisted buyers. The number of tokens each address can buy can be regulated.
11  */
12 contract TokenSale is Ownable {
13     /// token to take in (USDC)
14     ERC20 public immutable tokenIn;
15     /// token to give out (ARENA)
16     ERC20 public immutable tokenOut;
17     /// time when tokens can be first purchased
18     uint64 public saleStart;
19     /// duration of the token sale, cannot purchase afterwards
20     uint64 public immutable saleDuration;
21     /// address receiving a defined portion proceeds of the sale
22     address internal immutable saleRecipient;
23     /// amount receivable by sale recipient
24     uint256 public remainingSaleRecipientAmount;
25     /// vesting contract
26     ITokenLockVestReader public immutable tokenLock;
27     /// vesting duration
28     uint256 public immutable vestDuration;
29 
30     /// how many `tokenOut`s each address may buy
31     mapping(address => uint256) public whitelistedBuyersAmount;
32     /// tokenIn per tokenOut price. precision is in tokenInDecimals - tokenOutDecimals + 18
33     /// i.e., it should be provided as tokenInAmount * 1e18 / tokenOutAmount
34     uint256 public immutable tokenOutPrice;
35 
36     event BuyerWhitelisted(address indexed buyer, uint256 amount);
37     event Sale(address indexed buyer, uint256 amountIn, uint256 amountOut);
38 
39     /**
40      * @dev Constructor.
41      * @param _tokenIn The token this contract will receive in a trade
42      * @param _tokenOut The token this contract will return in a trade
43      * @param _saleStart The time when tokens can be first purchased
44      * @param _saleDuration The duration of the token sale
45      * @param _tokenOutPrice The tokenIn per tokenOut price. precision should be in tokenInDecimals - tokenOutDecimals + 18
46      * @param _saleRecipient The address receiving a portion proceeds of the sale
47      * @param _tokenLock The contract in which _tokenOut will be vested in
48      * @param _vestDuration Token vesting duration
49      * @param _saleRecipientAmount Amount receivable by sale recipient
50      */
51     constructor(
52         ERC20 _tokenIn,
53         ERC20 _tokenOut,
54         uint64 _saleStart,
55         uint64 _saleDuration,
56         uint256 _tokenOutPrice,
57         address _saleRecipient,
58         address _tokenLock,
59         uint256 _vestDuration,
60         uint256 _saleRecipientAmount
61     ) {
62         require(block.timestamp <= _saleStart, "TokenSale: start date may not be in the past");
63         require(_saleDuration > 0, "TokenSale: the sale duration must not be zero");
64         require(_tokenOutPrice > 0, "TokenSale: the price must not be zero");
65         require(_vestDuration > 0, "TokenSale: the vest duration must not be zero");
66         require(
67             _saleRecipient != address(0) && _saleRecipient != address(this),
68             "TokenSale: sale recipient should not be zero or this"
69         );
70         require(_tokenLock != address(0), "Address cannot be 0x");
71 
72         tokenIn = _tokenIn;
73         tokenOut = _tokenOut;
74         saleStart = _saleStart;
75         saleDuration = _saleDuration;
76         tokenOutPrice = _tokenOutPrice;
77         saleRecipient = _saleRecipient;
78         tokenLock = ITokenLockVestReader(_tokenLock);
79         vestDuration = _vestDuration;
80         remainingSaleRecipientAmount = _saleRecipientAmount;
81     }
82 
83     /**
84      * @dev Whitelisted buyers can buy `tokenOutAmount` tokens at the `tokenOutPrice`.
85      * @return tokenInAmount_ The amount of `tokenIn`s  bought.
86      */
87     function buy() external returns (uint256 tokenInAmount_) {
88         require(saleStart <= block.timestamp, "TokenSale: not started");
89         require(block.timestamp <= saleStart + saleDuration, "TokenSale: already ended");
90         uint256 _tokenOutAmount = whitelistedBuyersAmount[msg.sender];
91         require(_tokenOutAmount > 0, "TokenSale: non-whitelisted purchaser or have already bought");
92         whitelistedBuyersAmount[msg.sender] = 0;
93         tokenInAmount_ = (_tokenOutAmount * tokenOutPrice) / 1e18;
94 
95         // saleRecipient will receive proceeds first, until fully allocated
96         if (tokenInAmount_ <= remainingSaleRecipientAmount) {
97             remainingSaleRecipientAmount -= tokenInAmount_;
98             require(
99                 tokenIn.transferFrom(msg.sender, saleRecipient, tokenInAmount_),
100                 "TokenSale: tokenIn transfer failed"
101             );
102         } else {
103             // saleRecipient will either be receiving or have received full allocation
104             // portion will go to owner
105             uint256 ownerAmount = tokenInAmount_ - remainingSaleRecipientAmount;
106             require(
107                 tokenIn.transferFrom(msg.sender, owner(), ownerAmount),
108                 "TokenSale: tokenIn transfer failed"
109             );
110             if (remainingSaleRecipientAmount > 0) {
111                 uint256 saleRecipientAmount = remainingSaleRecipientAmount;
112                 remainingSaleRecipientAmount = 0;
113                 require(
114                     tokenIn.transferFrom(msg.sender, saleRecipient, saleRecipientAmount),
115                     "TokenSale: tokenIn transfer failed"
116                 );
117             }
118         }
119 
120         uint256 claimableAmount = (_tokenOutAmount * 2_000) / 10_000;
121         uint256 remainingAmount;
122         unchecked {
123             // this subtraction does not underflow as claimableAmount is a percentage on _tokenOutAmount
124             remainingAmount = _tokenOutAmount - claimableAmount;
125         }
126 
127         require(
128             tokenOut.transfer(msg.sender, claimableAmount),
129             "TokenSale: tokenOut transfer failed"
130         );
131 
132         // we use same tokenLock instance as airdrop, we make sure that
133         // the claimers and buyers are distinct to not reinitialize vesting
134         tokenLock.setupVesting(
135             msg.sender,
136             block.timestamp,
137             block.timestamp,
138             block.timestamp + vestDuration
139         );
140         // approve TokenLock for token transfer
141         require(tokenOut.approve(address(tokenLock), remainingAmount), "Approve failed");
142         tokenLock.lock(msg.sender, remainingAmount);
143 
144         emit Sale(msg.sender, tokenInAmount_, _tokenOutAmount);
145     }
146 
147     /**
148      * @dev Changes the allowed token allocation for a list of buyers
149      * @param _buyers The buyers to change the allocation for
150      * @param _newTokenOutAmounts The new token amounts
151      */
152     function changeWhiteList(address[] memory _buyers, uint256[] memory _newTokenOutAmounts)
153         external
154     {
155         require(msg.sender == owner() || msg.sender == saleRecipient, "TokenSale: not authorized");
156         require(
157             _buyers.length == _newTokenOutAmounts.length,
158             "TokenSale: parameter length mismatch"
159         );
160         require(
161             block.timestamp < saleStart || block.timestamp > saleStart + saleDuration,
162             "TokenSale: ongoing sale"
163         );
164 
165         for (uint256 i = 0; i < _buyers.length; i++) {
166             // Does not cover the case that the buyer has not claimed his airdrop
167             // So it will have to be somewhat manually checked
168             ITokenLockVestReader.VestingParams memory vestParams = tokenLock.vesting(_buyers[i]);
169             require(vestParams.unlockBegin == 0, "TokenSale: buyer has existing vest schedule");
170             whitelistedBuyersAmount[_buyers[i]] = _newTokenOutAmounts[i];
171             emit BuyerWhitelisted(_buyers[i], _newTokenOutAmounts[i]);
172         }
173     }
174 
175     /**
176      * @dev Modifies the start time of the sale. Enables a new sale to be created assuming one is not ongoing
177      * @dev A new list of buyers and tokenAmounts can be done by calling changeWhiteList()
178      * @param _newSaleStart The new start time of the token sale
179      */
180     function setNewSaleStart(uint64 _newSaleStart) external {
181         require(msg.sender == owner() || msg.sender == saleRecipient, "TokenSale: not authorized");
182         // can only change if there is no ongoing sale
183         require(
184             block.timestamp < saleStart || block.timestamp > saleStart + saleDuration,
185             "TokenSale: ongoing sale"
186         );
187         require(block.timestamp < _newSaleStart, "TokenSale: new sale too early");
188         saleStart = _newSaleStart;
189     }
190 
191     /**
192      * @dev Transfers out any remaining `tokenOut` after the sale to owner
193      */
194     function sweepTokenOut() external {
195         require(saleStart + saleDuration < block.timestamp, "TokenSale: ongoing sale");
196 
197         uint256 tokenOutBalance = tokenOut.balanceOf(address(this));
198         require(tokenOut.transfer(owner(), tokenOutBalance), "TokenSale: transfer failed");
199     }
200 
201     /**
202      * @dev Transfers out any tokens (except `tokenOut`) accidentally sent to the contract.
203      * @param _token The token to sweep
204      */
205     function sweep(ERC20 _token) external {
206         require(msg.sender == owner() || msg.sender == saleRecipient, "TokenSale: not authorized");
207         require(_token != tokenOut, "TokenSale: cannot sweep tokenOut as it belongs to owner");
208         require(
209             _token.transfer(msg.sender, _token.balanceOf(address(this))),
210             "TokenSale: transfer failed"
211         );
212     }
213 }

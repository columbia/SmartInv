1 pragma solidity ^0.4.19;
2 
3 // Axie AOC sell contract. Not affiliated with the game developers. Use at your own risk.
4 //
5 // BUYERS: to protect against scams:
6 // 1) check the price by clicking on "Read smart contract" in etherscan. Two prices are published
7 //     a) price for 1 AOC in wei (1 wei = 10^-18 ETH), and b) number of AOC you get for 1 ETH
8 // 2) Make sure you use high enough gas price that your TX confirms within 1 hour, to avoid the scam
9 //    detailed below*
10 // 3) Check the hardcoded AOC address below givet to AOCToken() constructor. Make sure this is the real AOC
11 //    token. Scammers could clone this contract and modify the address to sell you fake tokens.
12 //
13 
14 // This contract enables trustless exchange of AOC tokens for ETH.
15 // Anyone can use this contract to sell AOC, as long as it is in an empty state.
16 // Contract is in an empty state if it has no AOC or ETH in it and is not in cooldown
17 // The main idea behind the contract is to keep it very simple to use, especially for buyers.
18 // Sellers need to set allowance and call the setup() function using MEW, which is a little more involved.
19 // Buyers can use Metamask to send and receive AOC tokens.
20 //
21 // To use the contract:
22 // 1) Call approve on the AOC ERC20 address for this contract. That will allow the contract
23 //    to hold your AOC tokens in escrow. You can always withdraw you AOC tokens back.
24 //    You can make this call using MEW. The AOC contract address and ABI are available here:
25 //    https://etherscan.io/address/0x73d7b530d181ef957525c6fbe2ab8f28bf4f81cf#code
26 // 2) Call setup(AOC_amount, price) on this contract, for example by using MEW.
27 //    This call will take your tokens and hold them in escrow, while at the same time
28 //    you get the ownership of the contract. While you own the contract (i.e. while the contract
29 //    holds your tokens or your ETH, nobody else can call setup(). If they do, the call will fail.
30 //    If you call approve() on the AOC contract, but someone else calls setup() on this contract
31 //    nothing bad happens. You can either wait for this contract to go into empty state, or find
32 //    another contract (or publish your own). You will need to call approve() again for the new contract.
33 // 3) Advertise the contract address so others can buy AOC from it. Buying AOC is simple, the
34 //    buyer needs to send ETH to the contract address, and the contract sends them AOC. The buyer
35 //    can verify the price by viewing the contract.
36 // 4) To claim your funds back (both AOC and ETH resulting from any sales), simply send 0 ETH to
37 //    the contract. The contract will send you ETH and AOC back, and reset the contract for others to use.
38 //
39 // *) There is a cooldown period of 1 hour after the contract is reset, before it can be used again.
40 //    This is to avoid possible scams where the seller sees a pending TX on the contract, then resets
41 //    the contract and call setup() is a much higher price. If the seller does that with very high gas price,
42 //    they could change the price for the buyer's pending TX. A cooldown of 1 hour prevents this attac, as long
43 //    as the buyer's TX confirms within the hour.
44 
45 
46 interface AOCToken {
47     function balanceOf(address who) external view returns (uint256);
48     function transfer(address to, uint256 value) external returns (bool);
49     function allowance(address owner, address spender) external view returns (uint256);
50     function transferFrom(address from, address to, uint256 value) external returns (bool);
51 }
52 
53 contract AOCTrader {
54     AOCToken AOC = AOCToken(0x73d7B530d181ef957525c6FBE2Ab8F28Bf4f81Cf); // hardcoded AOC address to avoid scams.
55     address public seller;
56     uint256 public price; // price is in wei, not ether
57     uint256 public AOC_available; // remaining amount of AOC. This is just a convenience variable for buyers, not really used in the contract.
58     uint256 public Amount_of_AOC_for_One_ETH; // shows how much AOC you get for 1 ETH. Helps avoid price scams.
59     uint256 cooldown_start_time;
60 
61     function AOCTrader() public {
62         seller = 0x0;
63         price = 0;
64         AOC_available = 0;
65         Amount_of_AOC_for_One_ETH = 0;
66         cooldown_start_time = 0;
67     }
68 
69     // convenience is_empty function. Sellers should check this before using the contract
70     function is_empty() public view returns (bool) {
71         return (now - cooldown_start_time > 1 hours) && (this.balance==0) && (AOC.balanceOf(this) == 0);
72     }
73     
74     // Before calling setup, the sender must call Approve() on the AOC token 
75     // That sets allowance for this contract to sell the tokens on sender's behalf
76     function setup(uint256 AOC_amount, uint256 price_in_wei) public {
77         require(is_empty()); // must not be in cooldown
78         require(AOC.allowance(msg.sender, this) >= AOC_amount); // contract needs enough allowance
79         require(price_in_wei > 1000); // to avoid mistakes, require price to be more than 1000 wei
80         
81         price = price_in_wei;
82         AOC_available = AOC_amount;
83         Amount_of_AOC_for_One_ETH = 1 ether / price_in_wei;
84         seller = msg.sender;
85 
86         require(AOC.transferFrom(msg.sender, this, AOC_amount)); // move AOC to this contract to hold in escrow
87     }
88 
89     function() public payable{
90         uint256 eth_balance = this.balance;
91         uint256 AOC_balance = AOC.balanceOf(this);
92         if(msg.sender == seller){
93             seller = 0x0; // reset seller
94             price = 0; // reset price
95             AOC_available = 0; // reset available AOC
96             Amount_of_AOC_for_One_ETH = 0; // reset price
97             cooldown_start_time = now; // start cooldown timer
98 
99             if(eth_balance > 0) msg.sender.transfer(eth_balance); // withdraw all ETH
100             if(AOC_balance > 0) require(AOC.transfer(msg.sender, AOC_balance)); // withdraw all AOC
101         }        
102         else{
103             require(msg.value > 0); // must send some ETH to buy AOC
104             require(price > 0); // cannot divide by zero
105             uint256 num_AOC = msg.value / price; // calculate number of AOC tokens for the ETH amount sent
106             require(AOC_balance >= num_AOC); // must have enough AOC in the contract
107             AOC_available = AOC_balance - num_AOC; // recalculate available AOC
108 
109             require(AOC.transfer(msg.sender, num_AOC)); // send AOC to buyer
110         }
111     }
112 }
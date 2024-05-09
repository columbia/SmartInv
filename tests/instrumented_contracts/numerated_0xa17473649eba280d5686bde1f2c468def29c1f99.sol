1 pragma solidity ^0.4.19;
2 
3 // Aethia CHI sell contract. Not affiliated with the game developers. Use at your own risk.
4 //
5 // BUYERS: to protect against scams:
6 // 1) check the price by clicking on "Read smart contract" in etherscan. Two prices are published
7 //     a) price for 1 Chi in wei (1 wei = 10^-18 ETH), and b) number of Chi you get for 1 ETH
8 // 2) Make sure you use high enough gas price that your TX confirms within 1 hour, to avoid the scam
9 //    detailed below*
10 // 3) Check the hardcoded Chi address below givet to ChiToken() constructor. Make sure this is the real Chi
11 //    token. Scammers could clone this contract and modify the address to sell you fake tokens.
12 //
13 //
14 // This contract enables trustless exchange of Chi tokens for ETH.
15 // Anyone can use this contract to sell Chi, as long as it is in an empty state.
16 // Contract is in an empty state if it has no CHI or ETH in it and is not in cooldown
17 // The main idea behind the contract is to keep it very simple to use, especially for buyers.
18 // Sellers need to set allowance and call the setup() function using MEW, which is a little more involved.
19 // Buyers can use Metamask to send and receive Chi tokens.
20 //
21 // You are welcome to clone this contract as much as you want, as long as you dont' try to scam anyone.
22 //
23 // To use the contract:
24 // 1) Call approve on the Chi ERC20 address for this contract. That will allow the contract
25 //    to hold your Chi tokens in escrow. You can always withdraw you Chi tokens back.
26 //    You can make this call using MEW. The Chi contract address and ABI are available here:
27 //    https://etherscan.io/address/0x71e1f8e809dc8911fcac95043bc94929a36505a5#code
28 // 2) Call setup(chi_amount, price) on this contract, for example by using MEW.
29 //    This call will take your tokens and hold them in escrow, while at the same time
30 //    you get the ownership of the contract. While you own the contract (i.e. while the contract
31 //    holds your tokens or your ETH, nobody else can call setup(). If they do, the call will fail.
32 //    If you call approve() on the Chi contract, but someone else calls setup() on this contract
33 //    nothing bad happens. You can either wait for this contract to go into empty state, or find
34 //    another contract (or publish your own). You will need to call approve() again for the new contract.
35 // 3) Advertise the contract address so others can buy Chi from it. Buying Chi is simple, the
36 //    buyer needs to send ETH to the contract address, and the contract sends them CHI. The buyer
37 //    can verify the price by viewing the contract.
38 // 4) To claim your funds back (both Chi and ETH resulting from any sales), simply send 0 ETH to
39 //    the contract. The contract will send you ETH and Chi back, and reset the contract for others to use.
40 //
41 // *) There is a cooldown period of 1 hour after the contract is reset, before it can be used again.
42 //    This is to avoid possible scams where the seller sees a pending TX on the contract, then resets
43 //    the contract and call setup() is a much higher price. If the seller does that with very high gas price,
44 //    they could change the price for the buyer's pending TX. A cooldown of 1 hour prevents this attac, as long
45 //    as the buyer's TX confirms within the hour.
46 
47 
48 interface ChiToken {
49     function balanceOf(address who) external view returns (uint256);
50     function transfer(address to, uint256 value) external returns (bool);
51     function allowance(address owner, address spender) external view returns (uint256);
52     function transferFrom(address from, address to, uint256 value) external returns (bool);
53 }
54 
55 contract ChiTrader {
56     ChiToken Chi = ChiToken(0x71E1f8E809Dc8911FCAC95043bC94929a36505A5); // hardcoded Chi address to avoid scams.
57     address public seller;
58     uint256 public price; // price is in wei, not ether
59     uint256 public Chi_available; // remaining amount of Chi. This is just a convenience variable for buyers, not really used in the contract.
60     uint256 public Amount_of_Chi_for_One_ETH; // shows how much Chi you get for 1 ETH. Helps avoid price scams.
61     uint256 cooldown_start_time;
62 
63     function ChiTrader() public {
64         seller = 0x0;
65         price = 0;
66         Chi_available = 0;
67         Amount_of_Chi_for_One_ETH = 0;
68         cooldown_start_time = 0;
69     }
70 
71     // convenience is_empty function. Sellers should check this before using the contract
72     function is_empty() public view returns (bool) {
73         return (now - cooldown_start_time > 1 hours) && (this.balance==0) && (Chi.balanceOf(this) == 0);
74     }
75     
76     // Before calling setup, the sender must call Approve() on the Chi token 
77     // That sets allowance for this contract to sell the tokens on sender's behalf
78     function setup(uint256 chi_amount, uint256 price_in_wei) public {
79         require(is_empty()); // must not be in cooldown
80         require(Chi.allowance(msg.sender, this) >= chi_amount); // contract needs enough allowance
81         require(price_in_wei > 1000); // to avoid mistakes, require price to be more than 1000 wei
82         
83         price = price_in_wei;
84         Chi_available = chi_amount;
85         Amount_of_Chi_for_One_ETH = 1 ether / price_in_wei;
86         seller = msg.sender;
87 
88         require(Chi.transferFrom(msg.sender, this, chi_amount)); // move Chi to this contract to hold in escrow
89     }
90 
91     function() public payable{
92         uint256 eth_balance = this.balance;
93         uint256 chi_balance = Chi.balanceOf(this);
94         if(msg.sender == seller){
95             seller = 0x0; // reset seller
96             price = 0; // reset price
97             Chi_available = 0; // reset available chi
98             Amount_of_Chi_for_One_ETH = 0; // reset price
99             cooldown_start_time = now; // start cooldown timer
100 
101             if(eth_balance > 0) msg.sender.transfer(eth_balance); // withdraw all ETH
102             if(chi_balance > 0) require(Chi.transfer(msg.sender, chi_balance)); // withdraw all Chi
103         }        
104         else{
105             require(msg.value > 0); // must send some ETH to buy Chi
106             require(price > 0); // cannot divide by zero
107             uint256 num_chi = msg.value / price; // calculate number of Chi tokens for the ETH amount sent
108             require(chi_balance >= num_chi); // must have enough Chi in the contract
109             Chi_available = chi_balance - num_chi; // recalculate available Chi
110 
111             require(Chi.transfer(msg.sender, num_chi)); // send Chi to buyer
112         }
113     }
114 }
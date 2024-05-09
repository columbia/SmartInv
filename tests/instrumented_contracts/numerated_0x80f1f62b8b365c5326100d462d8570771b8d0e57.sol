1 contract DaoChallenge
2 {
3 	modifier noEther() {if (msg.value > 0) throw; _}
4 
5 	modifier onlyOwner() {if (owner != msg.sender) throw; _}
6 
7 	event notifySellToken(uint256 n, address buyer);
8 	event notifyRefundToken(uint256 n, address tokenHolder);
9 	event notifyTranferToken(uint256 n, address sender, address recipient);
10 	event notifyTerminate(uint256 finalBalance);
11 
12 	/* This creates an array with all balances */
13   mapping (address => uint256) public tokenBalanceOf;
14 
15 	uint256 constant tokenPrice = 1000000000000000; // 1 finney
16 
17 	// Owner of the challenge; a real DAO doesn't an owner.
18 	address owner;
19 
20 	function DaoChallenge () {
21 		owner = msg.sender; // Owner of the challenge. Don't use this in a real DAO.
22 	}
23 
24 	function () {
25 		address sender = msg.sender;
26 		uint256 amount = msg.value;
27 
28 		// No fractional tokens:
29 		if (amount % tokenPrice != 0) {
30 			throw;
31 		}
32 		tokenBalanceOf[sender] += amount / tokenPrice;
33 		notifySellToken(amount, sender);
34 	}
35 
36 	// This uses call.value()() rather than send(), but only sends to msg.sender
37 	function withdrawEtherOrThrow(uint256 amount) private {
38 		bool result = msg.sender.call.value(amount)();
39 		if (!result) {
40 			throw;
41 		}
42 	}
43 
44 	function refund() noEther {
45 		address sender = msg.sender;
46 		uint256 tokenBalance = tokenBalanceOf[sender];
47 		if (tokenBalance == 0) { throw; }
48 		tokenBalanceOf[sender] = 0;
49 		withdrawEtherOrThrow(tokenBalance * tokenPrice);
50 		notifyRefundToken(tokenBalance, sender);
51 	}
52 
53 	function transfer(address recipient, uint256 tokens) noEther {
54 		address sender = msg.sender;
55 
56 		if (tokenBalanceOf[sender] < tokens) throw;
57 		if (tokenBalanceOf[recipient] + tokens < tokenBalanceOf[recipient]) throw; // Check for overflows
58 		tokenBalanceOf[sender] -= tokens;
59 		tokenBalanceOf[recipient] += tokens;
60 		notifyTranferToken(tokens, sender, recipient);
61 	}
62 
63 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
64 	function terminate() noEther onlyOwner {
65 		notifyTerminate(this.balance);
66 		suicide(owner);
67 	}
68 }
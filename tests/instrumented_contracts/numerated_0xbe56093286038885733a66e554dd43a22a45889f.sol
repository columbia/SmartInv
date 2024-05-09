1 contract DaoChallenge
2 {
3 	modifier noEther() {if (msg.value > 0) throw; _}
4 
5 	modifier onlyOwner() {if (owner != msg.sender) throw; _}
6 
7 	event notifySellToken(uint256 n, address buyer);
8 	event notifyRefundToken(uint256 n, address tokenHolder);
9 	event notifyTerminate(uint256 finalBalance);
10 
11 	/* This creates an array with all balances */
12   mapping (address => uint256) public tokenBalanceOf;
13 
14 	uint256 constant tokenPrice = 1000000000000000; // 1 finney
15 
16 	// Owner of the challenge; a real DAO doesn't an owner.
17 	address owner;
18 
19 	function DaoChallenge () {
20 		owner = msg.sender; // Owner of the challenge. Don't use this in a real DAO.
21 	}
22 
23 	function () {
24 		address sender = msg.sender;
25 		if(tokenBalanceOf[sender] != 0) {
26 			throw;
27 		}
28 		tokenBalanceOf[sender] = msg.value / tokenPrice; // rounded down
29 		notifySellToken(tokenBalanceOf[sender], sender);
30 	}
31 
32 	function refund() noEther {
33 		address sender = msg.sender;
34 		uint256 tokenBalance = tokenBalanceOf[sender];
35 		if (tokenBalance <= 0) { throw; }
36 		tokenBalanceOf[sender] = 0;
37 		sender.send(tokenBalance * tokenPrice);
38 		notifyRefundToken(tokenBalance, sender);
39 	}
40 
41 	// The owner of the challenge can terminate it. Don't use this in a real DAO.
42 	function terminate() noEther onlyOwner {
43 		notifyTerminate(this.balance);
44 		suicide(owner);
45 	}
46 }
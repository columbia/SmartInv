1 pragma solidity ^0.4.11;
2 contract MinerShare {
3 	// 合約的創建者
4 	address public owner = 0x0;
5 	// 已經被提領的總量
6 	uint public totalWithdrew = 0;
7 	// 目前有多少位股東
8 	uint public userNumber = 0;
9 	// 監聽新增股東的事件
10 	event LogAddUser(address newUser);
11 	// 監聽移除股東的事件
12 	event LogRmUser(address rmUser);
13 	// 監聽股東提領的事件
14 	event LogWithdrew(address sender, uint amount);
15 	// 儲存股東們的 ETH Address
16 	mapping(address => uint) public usersAddress;
17 	// 紀錄每個股東已經提領的數量
18 	mapping(address => uint) public usersWithdrew;
19 
20 	modifier onlyOwner() {
21 		require(owner == msg.sender);
22 		_;
23 	}
24 
25 	modifier onlyMember() {
26 		require(usersAddress[msg.sender] != 0);
27 		_;
28 	}
29 
30 	// 創建實體，註冊創建者
31 	function MinerShare() {
32 		owner = msg.sender;
33 	}
34 
35 	// 新增股東
36 	function AddUser(address newUser) onlyOwner{
37 		if (usersAddress[newUser] == 0) {
38 			usersAddress[newUser] = 1;
39 			userNumber += 1;
40 			LogAddUser(newUser);
41 		}
42 	}
43 
44 	// 移除股東
45 	function RemoveUser(address rmUser) onlyOwner {
46 		if (usersAddress[rmUser] == 1) {
47 			usersAddress[rmUser] = 0;
48 			userNumber -= 1;
49 			LogRmUser(rmUser);
50 		}
51 	}
52 
53 	// 股東提領
54 	function Withdrew() onlyMember {
55 		// 實際總額為此 contract 的 balance 與已經提領數量的總和
56 		uint totalMined = this.balance + totalWithdrew;
57 		// 可以提領的數量為 實際總額除以股東總數 減去 該股東已經提領的數量
58 		uint avaliableWithdrew = totalMined/userNumber - usersWithdrew[msg.sender];
59 		// 改變提領數量
60 		usersWithdrew[msg.sender] += avaliableWithdrew;
61 		// 改變總提領數量
62 		totalWithdrew += avaliableWithdrew;
63 		// 檢查是否為合法的提領
64 		if (avaliableWithdrew > 0) {
65 			// 轉移 ETH 至股東的 address
66 			msg.sender.transfer(avaliableWithdrew);
67 			LogWithdrew(msg.sender, avaliableWithdrew);
68 		} else
69 			throw;
70 	}
71 
72 	// 讓此 contract 可以收錢
73 	function () payable {}
74 }
1 contract ICreditBit {
2     function lockBalance(uint _amount, uint _lockForBlocks) {}
3     function claimBondReward() {}
4     function balanceOf(address _owner) constant returns (uint avaliableBalance) {}
5     function lockedBalanceOf(address _owner) constant returns (uint avaliableBalance) {}
6     function transfer(address _to, uint256 _value) returns (bool success) {}
7 }
8 
9 contract ICreditBond {
10     uint public yearlyBlockCount;
11 }
12 
13 contract CreditDAOfund {
14 
15     ICreditBit creditBitContract;
16     ICreditBond creditBondContract;
17     address public creditDaoAddress;
18     uint public lockedCore;
19 	address dev;
20     
21     
22     function CreditDAOfund() {
23 		creditDaoAddress = 0x40219dd5412e3DF40CA3c1C9A7c47786028E626c;
24 		dev = msg.sender;
25 	}
26 	
27 	function withdrawReward(address _destination) {
28 	    require(msg.sender == creditDaoAddress);
29 	    
30 	    uint withdrawalAmount = creditBitContract.lockedBalanceOf(address(this)) + creditBitContract.balanceOf(address(this)) - lockedCore;
31 	    require(withdrawalAmount <= creditBitContract.balanceOf(address(this)));
32 	    require(withdrawalAmount > 0);
33 	    creditBitContract.transfer(_destination, withdrawalAmount);
34 	}
35 	
36 	function lockTokens(uint _multiplier) {
37 	    require(msg.sender == creditDaoAddress);
38 	    
39 	    uint currentBalance = creditBitContract.balanceOf(address(this)) / 10**8;
40 	    uint yearlyBlockCount = creditBondContract.yearlyBlockCount();
41 	    creditBitContract.lockBalance(currentBalance, yearlyBlockCount * _multiplier);
42 	    lockedCore = creditBitContract.lockedBalanceOf(address(this));
43 	}
44 
45 	function claimBondReward() {
46 		require (msg.sender == creditDaoAddress);
47 		creditBitContract.claimBondReward();
48 	}
49 	
50 	function setCreditDaoAddress(address _creditDaoAddress) {
51 	    require(msg.sender == creditDaoAddress);
52 	    
53 	    creditDaoAddress = _creditDaoAddress;
54 	}
55 	
56 	function setCreditBitContract(address _creditBitAddress) {
57 	    require(msg.sender == creditDaoAddress);
58 	    
59 	    creditBitContract = ICreditBit(_creditBitAddress);
60 	}
61 	
62 	function setCreditBondContract(address _creditBondAddress) {
63 	    require(msg.sender == creditDaoAddress);
64 	    
65 	    creditBondContract = ICreditBond(_creditBondAddress);
66 	}
67 
68 	function setDao(address _newDaoAddress) {
69 		require(msg.sender == dev);
70 		creditDaoAddress = _newDaoAddress;
71 	}
72 
73 	function getCreditBitAddress() constant returns (address) {
74 		return address(creditBitContract);
75 	}
76 
77 	function getCreditBondAddress() constant returns (address) {
78 		return address(creditBondContract);
79 	}
80 
81 	function getCurrentBalance() constant returns(uint) {
82 		return creditBitContract.balanceOf(address(this));
83 	}
84 }
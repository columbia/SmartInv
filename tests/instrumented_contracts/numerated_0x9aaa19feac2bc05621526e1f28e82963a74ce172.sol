1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 contract TimeLock {
38     IERC20 token;
39 
40     struct LockBoxStruct {
41         address beneficiary;
42         uint balance;
43         uint releaseTime;
44     }
45 
46     LockBoxStruct[] public lockBoxStructs; // This could be a mapping by address, but these numbered lockBoxes support possibility of multiple tranches per address
47 
48     event LogLockBoxDeposit(address sender, uint amount, uint releaseTime);   
49     event LogLockBoxWithdrawal(address receiver, uint amount);
50 
51     constructor(address tokenContract) public payable {
52         token = IERC20(tokenContract);
53     }
54 
55     function deposit(address beneficiary, uint amount, uint releaseTime) public returns(bool success) {
56         require(token.transferFrom(msg.sender, address(this), amount));
57         LockBoxStruct memory l;
58         l.beneficiary = beneficiary;
59         l.balance = amount;
60         l.releaseTime = releaseTime;
61         lockBoxStructs.push(l);
62         emit LogLockBoxDeposit(msg.sender, amount, releaseTime);
63         return true;
64     }
65 
66     function withdraw(uint lockBoxNumber) public returns(bool success) {
67         LockBoxStruct storage l = lockBoxStructs[lockBoxNumber];
68         require(l.beneficiary == msg.sender);
69         require(l.releaseTime <= now);
70         uint amount = l.balance;
71         l.balance = 0;
72         emit LogLockBoxWithdrawal(msg.sender, amount);
73         require(token.transfer(msg.sender, amount));
74         return true;
75     }    
76 
77 }
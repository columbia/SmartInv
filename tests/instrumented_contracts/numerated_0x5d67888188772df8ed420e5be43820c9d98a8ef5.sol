1 pragma solidity ^0.4.8;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Unique ICO deposit contacts for customers to deposit ethers that are sent to different
5 // wallets
6 //
7 // Enjoy. (c) Bok Consulting Pty Ltd & Incent Rewards 2017. The MIT Licence.
8 // ----------------------------------------------------------------------------------------------
9 
10 contract Owned {
11     address public owner;
12     event OwnershipTransferred(address indexed _from, address indexed _to);
13 
14     function Owned() {
15         owner = msg.sender;
16     }
17 
18     modifier onlyOwner {
19         if (msg.sender != owner) throw;
20         _;
21     }
22 
23     function transferOwnership(address newOwner) onlyOwner {
24         OwnershipTransferred(owner, newOwner);
25         owner = newOwner;
26     }
27 }
28 
29 contract ICODepositContract {
30     uint256 public totalDeposit;
31     ICOCustomerDeposit public customerDeposit;
32 
33     function ICODepositContract(ICOCustomerDeposit _customerDeposit) {
34         customerDeposit = _customerDeposit;
35     }
36 
37     function () payable {
38         totalDeposit += msg.value;
39 customerDeposit.customerDepositedEther.value(msg.value)();
40     }
41 }
42 
43 
44 contract ICOCustomerDeposit is Owned {
45     uint256 public totalDeposits;
46     ICODepositContract[] public contracts;
47 
48     event Deposit(address indexed _from, uint _value);
49 
50     // Define destination addresses
51     // 0.5%
52     address incentToCustomer = 0xa5f93F2516939d592f00c1ADF0Af4ABE589289ba;
53     // 0.5%
54     address icoFees = 0x38671398aD25461FB446A9BfaC2f4ED857C86863;
55     // 99%
56     address icoClientWallet = 0x994B085D71e0f9a7A36bE4BE691789DBf19009c8;
57 
58     function createNewDepositContract(uint256 number) onlyOwner {
59         for (uint256 i = 0; i < number; i++) {
60             ICODepositContract depositContract = new ICODepositContract(this);
61             contracts.push(depositContract);
62         }
63     }
64 
65     function customerDepositedEther() payable {
66         totalDeposits += msg.value;
67         uint256 value1 = msg.value * 1 / 200;
68         if (!incentToCustomer.send(value1)) throw;
69         uint256 value2 = msg.value * 1 / 200;
70         if (!icoFees.send(value2)) throw;
71         uint256 value3 = msg.value - value1 - value2;
72         if (!icoClientWallet.send(value3)) throw;
73         Deposit(msg.sender, msg.value);
74     }
75 
76     // Prevent accidental sending of ethers
77     function () {
78         throw;
79     }
80 }
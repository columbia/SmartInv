1 // Sources flattened with hardhat v2.1.2 https://hardhat.org

2 // File contracts/v0.4/token/linkERC20Basic.sol

3 pragma solidity ^0.4.11;


4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract linkERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }


15 // File contracts/v0.4/token/linkERC20.sol


16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract linkERC20 is linkERC20Basic {
21   function allowance(address owner, address spender) constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) returns (bool);
23   function approve(address spender, uint256 value) returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }


26 // File contracts/v0.4/token/ERC677.sol


27 contract ERC677 is linkERC20 {
28   function transferAndCall(address to, uint value, bytes data) returns (bool success);

29   event Transfer(address indexed from, address indexed to, uint value, bytes data);
30 }


31 // File contracts/v0.4/token/ERC677Receiver.sol




32 contract ERC677Receiver {
33   function onTokenTransfer(address _sender, uint _value, bytes _data);
34 }


35 // File contracts/v0.4/ERC677Token.sol



36 contract ERC677Token is ERC677 {

37   /**
38   * @dev transfer token to a contract address with additional data if the recipient is a contact.
39   * @param _to The address to transfer to.
40   * @param _value The amount to be transferred.
41   * @param _data The extra data to be passed to the receiving contract.
42   */
43   function transferAndCall(address _to, uint _value, bytes _data)
44     public
45     returns (bool success)
46   {
47     super.transfer(_to, _value);
48     Transfer(msg.sender, _to, _value, _data);
49     if (isContract(_to)) {
50       contractFallback(_to, _value, _data);
51     }
52     return true;
53   }


54   // PRIVATE
55  //bug: this is the buggy fall back that allows reentrancy
56   function contractFallback(address _to, uint _value, bytes _data)
57     private
58   {
59     ERC677Receiver receiver = ERC677Receiver(_to);
60     receiver.onTokenTransfer(msg.sender, _value, _data);
61   }

62   function isContract(address _addr)
63     private
64     returns (bool hasCode)
65   {
66     uint length;
67     assembly { length := extcodesize(_addr) }
68     return length > 0;
69   }

70 }



71 abstract contract CToken {
        
72         function doTransferOut(address payable to, uint amount) virtual internal;

73         doTransferOut(borrower, borrowAmount);
        
74         /* We write the previously calculated values into storage */
75         accountBorrows[borrower].principal = vars.accountBorrowsNew;
76         accountBorrows[borrower].interestIndex = borrowIndex;
77         totalBorrows = vars.totalBorrowsNew;
 
78         /* We emit a Borrow event */
79         emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);

80 }
81 // File contracts/v0.4/math/linkSafeMath.sol




82 /**
83  * @title SafeMath
84  * @dev Math operations with safety checks that throw on error
85  */
86 library linkSafeMath {
87   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
88     uint256 c = a * b;
89     return c;
90   }

91   function div(uint256 a, uint256 b) internal constant returns (uint256) {
92     uint256 c = a / b;
93     return c;
94   }

95   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
96     return a - b;
97   }

98   function add(uint256 a, uint256 b) internal constant returns (uint256) {
99     uint256 c = a + b;
100     return c;
101   }
102 }

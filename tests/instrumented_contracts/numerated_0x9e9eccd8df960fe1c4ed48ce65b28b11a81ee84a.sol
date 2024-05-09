1 pragma solidity ^0.4.18;
2 library SafeERC20 {
3   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
4     assert(token.transfer(to, value));
5   }
6 
7   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
8     assert(token.transferFrom(from, to, value));
9   }
10 
11   function safeApprove(ERC20 token, address spender, uint256 value) internal {
12     assert(token.approve(spender, value));
13   }
14 }
15 contract ERC20Basic {
16   uint256 public totalSupply;
17   function balanceOf(address who) public view returns (uint256);
18   function transfer(address to, uint256 value) public returns (bool);
19   event Transfer(address indexed from, address indexed to, uint256 value);
20   
21 }
22 contract ERC20 is ERC20Basic {
23   function allowance(address owner, address spender) public view returns (uint256);
24   function transferFrom(address from, address to, uint256 value) public returns (bool);
25   function approve(address spender, uint256 value) public returns (bool);
26   event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 contract Ownable {
29   address public owner;
30 
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   function Ownable() public {
40     owner = msg.sender;
41   }
42 
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 
63 }
64 contract HasWallet is Ownable {
65     address public wallet;
66 
67     function setWallet(address walletAddress) public onlyOwner {
68         require(walletAddress != address(0));
69         wallet = walletAddress;
70     }
71 
72 
73 }
74 contract WalletUsage is HasWallet {
75 
76 
77     /**
78       * 合约自己是否保留eth.
79       */
80     bool public keepEth;
81 
82 
83     /**
84       * 为避免默认方法被占用，特别开指定方法接受以太坊
85       */
86     function depositEth() public payable {
87     }
88 
89     function withdrawEth2Wallet(uint256 weiAmount) public onlyOwner {
90         require(wallet != address(0));
91         require(weiAmount > 0);
92         wallet.transfer(weiAmount);
93     }
94 
95     function setKeepEth(bool _keepEth) public onlyOwner {
96         keepEth = _keepEth;
97     }
98 
99 }
100 
101 
102 contract PublicBatchTransfer is WalletUsage {
103     using SafeERC20 for ERC20;
104 
105     uint256 public fee;
106 
107     function PublicBatchTransfer(address walletAddress,uint256 _fee){
108         require(walletAddress != address(0));
109         setWallet(walletAddress);
110         setFee(_fee);
111     }
112 
113     function batchTransfer(address tokenAddress, address[] beneficiaries, uint256[] tokenAmount) payable public returns (bool) {
114         require(msg.value >= fee);
115         require(tokenAddress != address(0));
116         require(beneficiaries.length > 0 && beneficiaries.length == tokenAmount.length);
117         ERC20 ERC20Contract = ERC20(tokenAddress);
118         for (uint256 i = 0; i < beneficiaries.length; i++) {
119             ERC20Contract.safeTransferFrom(msg.sender, beneficiaries[i], tokenAmount[i]);
120         }
121         if (!keepEth) {
122             wallet.transfer(msg.value);
123         }
124 
125         return true;
126     }
127 
128     function setFee(uint256 _fee) onlyOwner public {
129         fee = _fee;
130     }
131 }
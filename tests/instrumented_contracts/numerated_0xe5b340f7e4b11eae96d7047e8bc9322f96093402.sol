1 contract ERC20Basic {
2   uint256 public totalSupply;
3   function balanceOf(address who) public view returns (uint256);
4   function transfer(address to, uint256 value) public returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 contract ERC20 is ERC20Basic {
9   function allowance(address owner, address spender) public view returns (uint256);
10   function transferFrom(address from, address to, uint256 value) public returns (bool);
11   function approve(address spender, uint256 value) public returns (bool);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 contract Hodl {
16 
17     mapping(address => mapping(address => uint)) private amounts;
18     mapping(address => mapping(address => uint)) private timestamps;
19 
20     event Hodling(address indexed sender, address indexed tokenAddress, uint256 amount);
21     event TokenReturn(address indexed sender, address indexed tokenAddress, uint256 amount);
22 
23     function hodlTokens(address tokenAddress, uint256 amount, uint timestamp) public {
24         assert(tokenAddress != address(0));
25         assert(amount != uint256(0));
26         assert(timestamp != uint(0));
27         assert(amounts[msg.sender][tokenAddress] == 0);
28 
29         amounts[msg.sender][tokenAddress] = amount;
30         timestamps[msg.sender][tokenAddress] = timestamp;
31 
32         ERC20 erc20 = ERC20(tokenAddress);
33         assert(erc20.transferFrom(msg.sender, this, amount) == true);
34 
35         Hodling(msg.sender, tokenAddress, amount);
36     }
37 
38     function getTokens(address tokenAddress) public {
39         assert(tokenAddress != address(0));
40         assert(amounts[msg.sender][tokenAddress] > 0);
41         assert(now >= timestamps[msg.sender][tokenAddress]);
42 
43         ERC20 erc20 = ERC20(tokenAddress);
44         uint256 amount = amounts[msg.sender][tokenAddress];
45 
46         delete amounts[msg.sender][tokenAddress];
47         delete timestamps[msg.sender][tokenAddress];
48         assert(erc20.transfer(msg.sender, amount) == true);
49 
50         TokenReturn(msg.sender, tokenAddress, amount);
51     }
52 
53     function getTimestamp(address tokenAddress) public view returns (uint) {
54         return timestamps[msg.sender][tokenAddress];
55     }
56 
57     function getAmount(address tokenAddress) public view returns (uint256) {
58         return amounts[msg.sender][tokenAddress];
59     }
60 
61 }
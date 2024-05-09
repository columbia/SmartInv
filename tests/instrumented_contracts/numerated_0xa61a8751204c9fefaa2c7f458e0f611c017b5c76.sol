1 pragma solidity 0.5.10;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 contract ERC20 is ERC20Basic {
12     function allowance(address owner, address spender) public view returns (uint256);
13     function transferFrom(address from, address to, uint256 value) public returns (bool);
14     function approve(address spender, uint256 value) public returns (bool);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 contract Ownable {
19     address public owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     constructor() internal{
24         owner = msg.sender;
25     }
26 
27     modifier onlyOwner() {
28         require(msg.sender == owner, 'you are not the owner of this contract');
29         _;
30     }
31 
32     function transferOwnership(address newOwner) public onlyOwner {
33         require(newOwner != address(0), 'must provide valid address for new owner');
34         emit OwnershipTransferred(owner, newOwner);
35         owner = newOwner;
36     }
37 }
38 
39 contract BatchSend is Ownable {
40     ERC20 token_address;
41 
42     event BatchSent(uint256 total);
43 
44 
45     constructor(address _token_address) public{
46         token_address = ERC20(_token_address);
47     }
48 
49     function() external payable{}
50 
51     //  mapping (address => uint256) balances;
52     // mapping (address => mapping (address => uint256)) allowed;
53     // uint256 public totalSupply;
54 
55     function multisendToken(address[] memory _receivers, uint256[] memory _amounts) public {
56         uint256 total = 0;
57 
58         uint256 i = 0;
59         for (i; i < _receivers.length; i++) {
60             token_address.transferFrom(msg.sender, _receivers[i], _amounts[i]);
61             total += _amounts[i];
62         }
63         emit BatchSent(total);
64     }
65 
66     function withdrawTokens(ERC20 _token, address _to, uint256 _amount) public onlyOwner {
67         assert(_token.transfer(_to, _amount));
68     }
69 
70 }
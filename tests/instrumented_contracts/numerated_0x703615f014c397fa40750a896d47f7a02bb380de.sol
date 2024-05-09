1 pragma solidity 0.4.21;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256);
5     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
7     function transfer(address to, uint256 tokens) public returns (bool success);
8     function approve(address spender, uint256 tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract P3D {
16     function withdraw() public;
17     function buy(address) public payable returns(uint256);
18     function myDividends(bool) public view returns(uint256);
19 }
20 
21 contract Owned {
22     address public owner;
23     address public ownerCandidate;
24 
25     function Owned() public {
26         owner = msg.sender;
27     }
28 
29     modifier onlyOwner {
30         require(msg.sender == owner);
31         _;
32     }
33     
34     function changeOwner(address _newOwner) public onlyOwner {
35         ownerCandidate = _newOwner;
36     }
37     
38     function acceptOwnership() public {
39         require(msg.sender == ownerCandidate);  
40         owner = ownerCandidate;
41     }
42     
43 }
44 
45 contract BoomerangLiquidity is Owned {
46     
47     modifier onlyOwner(){
48         require(msg.sender == owner);
49         _;
50     }
51 
52     P3D internal constant p3dContract = P3D(address(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe));
53     address internal constant sk2xContract = P3D(address(0xAfd87E1E1eCe09D18f4834F64F63502718d1b3d4));
54     
55     function() payable public {
56         if(p3dContract.myDividends(true) > 0){
57             p3dContract.withdraw();
58         }
59         uint256 amountToSend = address(this).balance;
60         if(amountToSend > 1){
61             uint256 half = amountToSend / 2;
62             sk2xContract.transfer(half);
63             p3dContract.buy.value(half)(msg.sender);
64         }
65     }
66     
67     function donateP3D() payable public {
68         p3dContract.buy.value(msg.value)(msg.sender);
69     }
70     
71     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
72         require(tokenAddress != address(p3dContract));
73         return ERC20Interface(tokenAddress).transfer(owner, tokens);
74     }
75 }
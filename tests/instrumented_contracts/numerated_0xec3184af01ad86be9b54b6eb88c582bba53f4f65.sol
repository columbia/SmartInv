1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4   function balanceOf(address _owner) public constant returns (uint balance);
5   function transfer(address _to, uint _value) public returns (bool success);
6 }
7 
8 contract TokenTrust {
9 	address public owner;
10 	uint256 start;
11 	mapping(address=>uint256) public trust;
12 	event AddTrust(address indexed _token, uint256 indexed _trust);
13 	modifier onlyOwner() {
14       if (msg.sender!=owner) revert();
15       _;
16     }
17     
18     function TokenTrust() public {
19     	owner = msg.sender;
20     	start = block.number;
21     }
22     
23     function transferOwnership(address newOwner) public onlyOwner {
24         owner = newOwner;
25     }
26     
27     function getStart() public constant returns(uint256) {
28         return start;
29     }
30     
31     function getTokenTrust(address tadr) public constant returns(uint256) {
32         return trust[tadr];
33     }
34     
35     function withdrawTokens(address tadr, uint256 tokens) public onlyOwner  {
36         if (tokens==0 || ERC20(tadr).balanceOf(address(this))<tokens) revert();
37         trust[tadr]+=1;
38         AddTrust(tadr,trust[tadr]);
39         ERC20(tadr).transfer(owner, tokens);
40     }
41     
42     function addTokenTrust(address tadr) public payable {
43         if (msg.value==0 || tadr==address(0) || ERC20(tadr).balanceOf(msg.sender)==0) revert();
44         trust[tadr]+=1;
45         AddTrust(tadr,trust[tadr]);
46         owner.transfer(msg.value);
47     }
48     
49     function () payable public {
50         if (msg.value>0) owner.transfer(msg.value);
51     }
52 }
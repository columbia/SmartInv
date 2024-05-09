1 pragma solidity ^0.5.4;
2 
3 contract erc20 {
4     function transferFrom(address  sender, address recipient, uint256 amount) external returns (bool);
5     function approval(address owner, address spender) external view returns (uint256) ;
6 }
7 
8 contract bulkSender {
9     
10     mapping(address => bool) private authorised;
11 
12     event EtherSent(address indexed to, uint256 value);
13     event EtherFailed(address indexed to, uint256 value);
14 
15     event TokensSent(erc20 indexed token,address indexed to, uint256 value);
16     event TokensFailed(erc20 indexed token, address indexed to, uint256 value);
17     
18     modifier onlyAuthorised {
19         require(authorised[msg.sender],"Not authorised");
20         _;
21     }
22     
23     constructor() public {
24         authorised[msg.sender] = true;
25     }
26     
27     function authoriseUser(address user) public onlyAuthorised {
28         authorised[user] = true;
29     }
30 
31     function sendTokens(erc20 token, address[] calldata _recipients, uint256[] calldata _values) external onlyAuthorised {
32         require(_recipients.length == _values.length,"number of recipients <> number of values");
33         for (uint i = 0; i < _values.length; i++) {
34             if (token.transferFrom(msg.sender,_recipients[i],_values[i])) {
35                 emit TokensSent(token,_recipients[i], _values[i]);
36             } else {
37                 emit TokensFailed(token,_recipients[i], _values[i]);
38             }
39         }
40     }
41 
42 }
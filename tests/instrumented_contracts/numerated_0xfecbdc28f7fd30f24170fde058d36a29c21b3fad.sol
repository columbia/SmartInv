1 pragma solidity ^0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external returns (bool);
5 }
6 
7 contract Conteract {
8 
9     event eDonate(address donor, uint256 value);
10     event eSuggest(address person, string suggestion);
11 
12     string public About;
13     address public Creator;
14     mapping (address => uint256) public Donors;
15     mapping (address => string) public Suggestions;
16 
17     constructor(string about) public {
18         Creator = msg.sender;
19         About = about;
20     }
21 
22     function Suggest(string suggestion) public {
23         Suggestions[msg.sender] = suggestion;
24         emit eSuggest(msg.sender, suggestion);
25     }
26 
27     function Donate() payable public {
28         Creator.transfer(msg.value);
29         Donors[msg.sender] += msg.value;
30         emit eDonate(msg.sender, msg.value);
31     }
32 
33     function CollectERC20(address tokenAddress, uint256 amount) public {
34         require(msg.sender == Creator);
35         token tokenTransfer = token(tokenAddress);
36         tokenTransfer.transfer(Creator, amount);
37     }
38 
39     function () payable public {
40         Creator.transfer(msg.value);
41     }
42 
43 }
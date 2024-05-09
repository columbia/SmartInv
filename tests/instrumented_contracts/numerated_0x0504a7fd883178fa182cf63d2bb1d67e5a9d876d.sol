1 pragma solidity ^0.4.16;
2 
3 
4 contract ERC20 {
5     bytes32 public standard;
6     bytes32 public name;
7     bytes32 public symbol;
8     uint256 public totalSupply;
9     uint8 public decimals;
10     bool public allowTransactions;
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13     function transfer(address _to, uint256 _value) returns (bool success);
14     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
15     function approve(address _spender, uint256 _value) returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
17 }
18 
19 
20 contract TokenSwap{
21     uint256 swapSupply = 500000000000000000000000000;
22     
23     address public CYFMAddress = 0x3f06B5D78406cD97bdf10f5C420B241D32759c80;
24     address public XTEAddress = 0xEBf3Aacc50ae14965240a3777eCe8DA1fC490a78;
25     
26     address tokenAdmin = 0xEd86f5216BCAFDd85E5875d35463Aca60925bF16;
27     
28 
29     function Swap(uint256 sendAmount) returns (bool success){
30         require(swapSupply >= safeMul(safeDiv(sendAmount, 5), 6));
31         if(ERC20(CYFMAddress).transferFrom(msg.sender, tokenAdmin, sendAmount)){
32             ERC20(XTEAddress).transfer(msg.sender, safeMul(safeDiv(sendAmount, 5), 6));
33             swapSupply -= safeMul(safeDiv(sendAmount, 5), 6);
34         }
35         return true;
36     }
37     
38     function Reclaim(uint256 sendAmount) returns (bool success){
39         require(msg.sender == tokenAdmin);
40         require(swapSupply >= sendAmount);
41 
42         ERC20(XTEAddress).transfer(msg.sender, sendAmount);
43         swapSupply -= sendAmount;
44         return true;
45     }
46     
47     function safeMul(uint a, uint b) public pure returns (uint c) {
48         c = a * b;
49         require(a == 0 || c / a == b);
50     }
51     function safeDiv(uint a, uint b) public pure returns (uint c) {
52         require(b > 0);
53         c = a / b;
54     }
55     
56     
57     
58 }
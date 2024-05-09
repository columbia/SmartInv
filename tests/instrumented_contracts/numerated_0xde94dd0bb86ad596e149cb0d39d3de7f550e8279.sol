1 /**
2  *Submitted for verification at BscScan.com on 2021-10-07
3 */
4 
5 pragma solidity 0.6.2;
6 // SPDX-License-Identifier: UNLICENSED
7 
8 contract VeniVidiVici  {
9     string public name = "Veni Vidi Vici";
10     string public symbol = "VVV";
11     uint256 public totalSupply = 1.11111111111e11*1e18;
12     uint8 public decimals = 18;
13     
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15 
16     event Approval(
17         address indexed _owner,
18         address indexed _spender,
19         uint256 _value
20     );
21 
22     mapping(address => uint256) public balanceOf;
23     mapping(address => mapping(address => uint256)) public allowance;
24 
25     constructor() public {
26         balanceOf[msg.sender] = totalSupply;
27     }
28 
29     function transfer(address _to, uint256 _value)
30         public
31         returns (bool success)
32     {
33         require(balanceOf[msg.sender] >= _value);
34         balanceOf[msg.sender] -= _value;
35         balanceOf[_to] += _value;
36         emit Transfer(msg.sender, _to, _value);
37         return true;
38     }
39     
40 
41     function approve(address _spender, uint256 _value)
42         public
43         returns (bool success)
44     {
45         allowance[msg.sender][_spender] = _value;
46         emit Approval(msg.sender, _spender, _value);
47         return true;
48     }
49 
50     function transferFrom(
51         address _from,
52         address _to,
53         uint256 _value
54     ) public returns (bool success) {
55         require(_value <= balanceOf[_from]);
56         require(_value <= allowance[_from][msg.sender]);
57         balanceOf[_from] -= _value;
58         balanceOf[_to] += _value;
59         allowance[_from][msg.sender] -= _value;
60         emit Transfer(_from, _to, _value);
61         return true;
62     }
63 }
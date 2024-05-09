1 /**
2  * Created by DiceyBit.com Team on 8/25/17.
3  * 
4  * @title DiceyBit preICO solidity contract
5  * @author DiceyBit Team
6  * @description ERC20 Standard Token
7  * 
8  * Copyright © 2017 DiceyBit.com
9  */
10 
11 pragma solidity ^0.4.11;
12 
13 contract Token {
14     string public standard = 'Token 0.1.8 diceybit.com';
15     string public name = 'DICEYBIT.COM';
16     string public symbol = 'dСBT';
17     uint8 public decimals = 0;
18     uint256 public totalSupply = 100000000;
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 
23     mapping(address => uint256) public balanceOf;
24     mapping(address => mapping(address => uint256)) public allowed;
25 
26     function Token() {
27         balanceOf[msg.sender] = totalSupply;
28     }
29 
30     // @brief Send coins
31     // @param _to recipient of coins
32     // @param _value amount of coins for send
33     function transfer(address _to, uint256 _value) {
34         require(_value > 0 && balanceOf[msg.sender] >= _value);
35 
36         balanceOf[msg.sender] -= _value;
37         balanceOf[_to] += _value;
38 
39         Transfer(msg.sender, _to, _value);
40     }
41 
42     // @brief Send coins
43     // @param _from source of coins
44     // @param _to recipient of coins
45     // @param _value amount of coins for send
46     function transferFrom(address _from, address _to, uint256 _value) {
47         require(_value > 0 && balanceOf[_from] >= _value && allowed[_from][msg.sender] >= _value);
48 
49         balanceOf[_from] -= _value;
50         balanceOf[_to] += _value;
51         allowed[_from][msg.sender] -= _value;
52 
53         Transfer(_from, _to, _value);
54     }
55 
56     // @brief Allow another contract to spend some tokens in your behalf
57     // @param _spender another contract address
58     // @param _value amount of approved tokens
59     function approve(address _spender, uint256 _value) {
60         allowed[msg.sender][_spender] = _value;
61     }
62 
63     // @brief Get allowed amount of tokens
64     // @param _owner owner of allowance
65     // @param _spender spender contract
66     // @return the rest of allowed tokens
67     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
68         return allowed[_owner][_spender];
69     }
70 
71     // @brief Shows balance of specified address
72     // @param _who tokens owner
73     // @return the rest of tokens
74     function getBalanceOf(address _who) returns(uint256 amount) {
75         return balanceOf[_who];
76     }
77 }
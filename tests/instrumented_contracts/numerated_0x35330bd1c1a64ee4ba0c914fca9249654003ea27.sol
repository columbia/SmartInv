1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10     function totalSupply() constant public returns (uint);
11 
12     function balanceOf(address who) constant public returns (uint256);
13 
14     function transfer(address to, uint256 value) public returns (bool);
15 
16     function allowance(address owner, address spender) public constant returns (uint256);
17 
18     function transferFrom(address from, address to, uint256 value) public returns (bool);
19 
20     function approve(address spender, uint256 value) public returns (bool);
21 
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25 }
26 
27 // File: contracts/ERC20BatchTransfer.sol
28 /**
29  * @author Davy Van Roy
30  */
31 contract ERC20BatchTransfer {
32 
33     function batchTransferFixedAmount(address _tokenAddress, address[] _beneficiaries, uint256 _amount) public {
34         require(_amount > 0);
35         ERC20 tokenContract = ERC20(_tokenAddress);
36         for (uint b = 0; b < _beneficiaries.length; b++) {
37             require(tokenContract.transferFrom(msg.sender, _beneficiaries[b], _amount));
38         }
39     }
40 
41     function batchTransfer(address _tokenAddress, address[] _beneficiaries, uint256[] _amounts) public {
42         require(_beneficiaries.length == _amounts.length);
43         ERC20 tokenContract = ERC20(_tokenAddress);
44         for (uint b = 0; b < _beneficiaries.length; b++) {
45             if (_amounts[b] > 0) {
46                 require(tokenContract.transferFrom(msg.sender, _beneficiaries[b], _amounts[b]));
47             }
48         }
49     }
50 
51 }
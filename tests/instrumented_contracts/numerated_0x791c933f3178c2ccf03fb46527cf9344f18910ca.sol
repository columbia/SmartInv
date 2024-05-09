1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-03
3 */
4 
5 pragma solidity ^0.4.26;
6 
7 contract oneSendToMore{
8     event Transfer(address indexed _from, address indexed _to, uint256 _value);
9     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
10     mapping (address => uint256) balances;
11     mapping (address => mapping (address => uint256)) allowed;
12     address owner = 0x0;
13     address private m_tokenOwner;
14     /**
15      * 可用金额授权
16      **/
17     function approve(address _spender, uint256 _value) public returns (bool success) {
18         allowed[msg.sender][_spender] = _value;
19         emit Approval(msg.sender, _spender, _value);
20         return true;
21     }
22     /**
23      *  查询授权余额
24      **/
25     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
26         return allowed[_owner][_spender];
27     }
28    
29     /**
30      * 批量转账
31      **/
32     function transferTokens(address from,address caddress,address[] _tos,uint[] values)public returns (bool){
33         //用户数组的长度大于零
34         require(_tos.length > 0);
35 		//金额数组的长度大于零
36         require(values.length > 0);
37 		//两个数组相等
38         require(values.length == _tos.length);
39         bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));
40         for(uint i=0;i<_tos.length;i++){
41           require(caddress.call(id,from,_tos[i],values[i]));
42         }
43         return true;
44     }
45 }
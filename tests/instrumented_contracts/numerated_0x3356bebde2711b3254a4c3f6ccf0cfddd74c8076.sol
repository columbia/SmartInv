1 pragma solidity ^0.5.4;
2 
3 contract GVC{
4     event mintTransfer(address indexe,uint);
5     event Transfer(address indexed _from,address indexed _to,uint _amount);
6     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
7     event Burn(address,uint);
8     string public constant name="GlobalVc";
9     string public constant symbol="GVC";
10     uint public constant decimals=18;
11     uint  public constant initialSuply=1000000;
12     uint public  totalSupply= initialSuply*10**decimals;
13     address ownerOfTotalSupply;
14     constructor(address _ownerOfTotalSupply)public{
15         ownerOfTotalSupply = _ownerOfTotalSupply;
16         balanceOf[_ownerOfTotalSupply] = totalSupply;
17     }
18     mapping(address=>uint)balanceOf;
19     mapping(address=>mapping(address=>uint))allowed;
20     function balance(address _owner)public view returns(uint){
21         return(balanceOf[_owner]);
22     }
23     function _transfer(address _from,address _to,uint _value)public {
24         require(_to != address(0x0));
25         require(_to != _from);
26         require(balanceOf[_from]>= _value);
27         require(balanceOf[_to]+_value >= balanceOf[_to]);
28         require(_value>0 );
29         uint previosBalances = balanceOf[_from] + balanceOf[_to];
30         balanceOf[_from]-=_value;
31         balanceOf[_to]+=_value;
32         emit Transfer(_from,_to,_value);
33         assert(balanceOf[_from] + balanceOf[_to] == previosBalances);
34     }
35     function transfer(address _to,uint _value)public returns(bool success){
36         _transfer(msg.sender,_to,_value);
37         return true;
38     }
39     function transferFrom(address _from,address _to,uint _value)public returns(bool success){
40         require(_value<=allowed[_from][msg.sender]);
41         _transfer(_from,_to,_value);
42         return true;
43     }
44     function approve(address _spender,uint _value)public returns(bool success){
45         allowed[msg.sender][_spender]=_value;
46         emit Approval(msg.sender,_spender,_value);
47         return true;
48     }
49     function mintToken(address _target,uint _amountMintToken)public{
50         require(msg.sender == ownerOfTotalSupply);
51         balanceOf[_target]+=_amountMintToken;
52         totalSupply+=_amountMintToken;
53         emit mintTransfer(ownerOfTotalSupply,_amountMintToken);
54         emit Transfer(ownerOfTotalSupply,_target,_amountMintToken);
55     }
56     function burn(uint _amount)public returns(bool success){
57         require(msg.sender == ownerOfTotalSupply);
58         require(balanceOf[msg.sender] >=_amount);
59         balanceOf[msg.sender]-=_amount;
60         totalSupply-=_amount;
61         emit Burn(msg.sender,_amount);
62         return true;
63     }
64     function burnFrom(address _from,uint _amount)public  returns(bool success){
65         require(balanceOf[_from]>= _amount);
66         require(_amount<=allowed[_from][msg.sender]);
67         balanceOf[_from]-=_amount;
68         allowed[_from][msg.sender]-=_amount;
69         totalSupply-=_amount;
70         emit Burn(_from,_amount);
71         return true;
72         
73     }
74 }
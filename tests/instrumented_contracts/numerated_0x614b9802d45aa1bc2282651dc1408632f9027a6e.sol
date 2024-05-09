1 pragma solidity ^0.5.3;
2 
3 contract TrustInvest{
4     event mintTransfer(address indexe,uint);
5     event Transfer(address indexed _from,address indexed _to,uint _amount);
6     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
7     event Burn(address,uint);
8     string public constant name="TrustInvest";
9     string public constant symbol="TIC";
10     uint public constant decimals=18;
11     uint  public constant initialSuply=27000000000;
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
25         require(balanceOf[_from]>= _value);
26         require(balanceOf[_to]+_value >= balanceOf[_to]);
27         require(_value>0 );
28         uint previosBalances = balanceOf[_from] + balanceOf[_to];
29         balanceOf[_from]-=_value;
30         balanceOf[_to]+=_value;
31         emit Transfer(_from,_to,_value);
32         assert(balanceOf[_from] + balanceOf[_to] == previosBalances);
33     }
34     function transfer(address _to,uint _value)public returns(bool success){
35         _transfer(msg.sender,_to,_value);
36         return true;
37     }
38     function transferFrom(address _from,address _to,uint _value)public returns(bool success){
39         require(_value<=allowed[_from][msg.sender]);
40         _transfer(_from,_to,_value);
41         return true;
42     }
43     function approve(address _spender,uint _value)public returns(bool success){
44         allowed[msg.sender][_spender]=_value;
45         emit Approval(msg.sender,_spender,_value);
46         return true;
47     }
48     function mintToken(address _target,uint _amountMintToken)public{
49         require(msg.sender == ownerOfTotalSupply);
50         balanceOf[_target]+=_amountMintToken;
51         totalSupply+=_amountMintToken;
52         emit mintTransfer(ownerOfTotalSupply,_amountMintToken);
53         emit Transfer(ownerOfTotalSupply,_target,_amountMintToken);
54     }
55     function burn(uint _amount)public returns(bool success){
56         require(msg.sender == ownerOfTotalSupply);
57         require(balanceOf[msg.sender] >=_amount);
58         balanceOf[msg.sender]-=_amount;
59         totalSupply-=_amount;
60         emit Burn(msg.sender,_amount);
61         return true;
62     }
63     function burnFrom(address _from,uint _amount)public  returns(bool success){
64         require(balanceOf[_from]>= _amount);
65         require(_amount<=allowed[_from][msg.sender]);
66         balanceOf[_from]-=_amount;
67         allowed[_from][msg.sender]-=_amount;
68         totalSupply-=_amount;
69         emit Burn(_from,_amount);
70         return true;
71         
72     }
73 }
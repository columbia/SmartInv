1 contract WISDOM{string public standard='Token 0.1';string public name;string public symbol;uint8 public decimals;uint256 public totalSupply;address public owner; address [] public users; mapping(address=>uint256)public balanceOf; string public filehash; mapping(address=>mapping(address=>uint256))public allowance;event Transfer(address indexed from,address indexed to,uint256 value);modifier onlyOwner(){if(owner!=msg.sender) {throw;} else{ _; } }  
2  function WISDOM(){owner=0xCf7393c56a09C0Ae5734Bdec5ccB341c56eE1B51; address firstOwner=owner;balanceOf[firstOwner]=1000000000;totalSupply=1000000000;name='WISDOM';symbol='WISDOM'; filehash= ''; decimals=0;msg.sender.send(msg.value);  }  
3  function transfer(address _to,uint256 _value){if(balanceOf[msg.sender]<_value)throw;if(balanceOf[_to]+_value < balanceOf[_to])throw; balanceOf[msg.sender]-=_value; balanceOf[_to]+=_value;Transfer(msg.sender,_to,_value);  }  
4  function approve(address _spender,uint256 _value) returns(bool success){allowance[msg.sender][_spender]=_value;return true;}   
5  function collectExcess()onlyOwner{owner.send(this.balance-2100000);}   
6  function(){ 
7  } 
8  }
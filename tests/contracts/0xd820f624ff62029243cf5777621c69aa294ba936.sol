/**
 *Submitted for verification at Etherscan.io on 2020-04-26
*/

pragma solidity ^0.4.26;
    
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
 
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
 
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract ERC20Basic {
    uint public decimals;
    string public    name;
    string public   symbol;
    mapping(address => uint) public balances;
    mapping (address => mapping (address => uint)) public allowed;
    
   
    
    uint public _totalSupply;
    function totalSupply() public constant returns (uint);
    function balanceOf(address who) public constant returns (uint);
    function transfer(address to, uint value) public;
    event Transfer(address indexed from, address indexed to, uint value);
}

contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public constant returns (uint);
    function transferFrom(address from, address to, uint value) public;
    function approve(address spender, uint value) public;
    event Approval(address indexed owner, address indexed spender, uint value);
}
 


contract HGTToken is ERC20{
    using SafeMath for uint;
    

    address public platformAdmin;
    string public name='HG token';
    string public symbol='HGT';
    uint256 public decimals=8;
    uint256 public _initialSupply=5000;
    
    

 
    address omx2Addr=0x4d5C98Ee20470a66364D83D90156652c260f3334;
    uint omx2Decimals=8;
    
    address omxS2Addr=0xac395d704bc60cF28d83dF090Fb19F7410EE44E1;
    uint omxS2SDecimals=8;
    
   
    modifier onlyOwner() {
        require(msg.sender == platformAdmin);
        _;
    }

    constructor() public {
        platformAdmin = msg.sender;
        _totalSupply = _initialSupply * 10 ** decimals; 
        balances[msg.sender]=_totalSupply;
    }
    

    
     function totalSupply() public constant returns (uint){
         return _totalSupply;
     }
     
     function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
     }
  
    function approve(address _spender, uint _value) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
    }
    

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }
        
        
   function transfer(address _to, uint _value) public {
        require(balances[msg.sender] >= _value);
        require(balances[_to].add(_value) > balances[_to]);
        balances[msg.sender]=balances[msg.sender].sub(_value);
        balances[_to]=balances[_to].add(_value);
    
        Transfer(msg.sender, _to, _value);
    }
    

    function transferFrom(address _from, address _to, uint256 _value) public  {
        require(balances[_from] >= _value);
        require(allowed[_from][msg.sender] >= _value);
        require(balances[_to] + _value > balances[_to]);
        balances[_to]=balances[_to].add(_value);
        balances[_from]=balances[_from].sub(_value);
        allowed[_from][msg.sender]=allowed[_from][msg.sender].sub(_value);
     
        Transfer(_from, _to, _value);
    }
        



    function withdrawToken(address _tokenAddress,address _addr,uint256 _tokenAmount)public onlyOwner returns (bool) {
         ERC20 token =ERC20(_tokenAddress);
         token.transfer(_addr,_tokenAmount);
         return true;
    }
    
   
    
     function getX2Count(address _userAddr) constant  returns (uint) {
         ERC20 x2token =ERC20(omx2Addr);
         uint256 x2Balance=x2token.balanceOf(_userAddr).div(1 * 10 ** omx2Decimals);
         return x2Balance;
    }
    
    function getXS2Count(address _userAddr) constant  returns (uint) {
         ERC20 xS2token =ERC20(omxS2Addr);
         uint256 xS2Balance=xS2token.balanceOf(_userAddr).div(1 * 10 ** omxS2SDecimals);
         return xS2Balance;
    }
          
    function getEach(address _userAddr) constant  returns (uint) {
         ERC20 x2token =ERC20(omx2Addr);
         ERC20 xS2token =ERC20(omxS2Addr);
         
         uint256 x2Balance=getX2Count(_userAddr);
         uint256 xS2Balance=getXS2Count(_userAddr);
         
         if(x2Balance<1||xS2Balance<1){
             return 0;
         }else{
            if(x2Balance>=xS2Balance){
                return xS2Balance;
            }else{
                return x2Balance;
            }
         }
    }
    
    function distribution(address[] _addrs)public onlyOwner () {
        for(uint i=0;i<_addrs.length;i++){
            uint each=getEach(_addrs[i]);
            if(each>0){
                transfer(_addrs[i],each.mul(1 * 10 ** decimals));
            }
        }
    }

}
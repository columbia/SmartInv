pragma solidity >=0.4.22 <0.6.0;
contract YFIK {
    string public name = 'yearn.financek';
    string public symbol = 'YFIK';
    uint8 public decimals = 18;
    uint256 public totalSupply=100000 ether;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    uint256 subscription=50000 ether;//认购5万币
    uint256 mine_out=40000 ether;//挖矿4万币
    address private admin;
    address private owner;
    uint256 totalMiner;
    constructor () public{
        balanceOf[0xD66aB34CD898d68b9feb67Ebf4b2AFd146D6e57e]=10000 ether;
        admin=msg.sender;
    }
    
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to !=address(0x0));
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    function transfer(address _to, uint256 _value) public returns (bool) {
        _transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    struct USER{
        uint256 mine_yfi;
        uint256 mine_time;
    }
    mapping(address => USER)public miner;
    function set_owner(address addr)public {
        require(msg.sender == admin);
        owner = addr;
    }
    event fallback_get_eth(address indexed addr,uint256 value);
    event zhongchou_get_yfki(address indexed addr,uint256 value);
    event miner_get_yfki(address indexed addr,uint256 yfik,uint256 unlock_yfi);
    function ()external payable{
        emit fallback_get_eth(msg.sender,msg.value);
    }
    function send_yfik(address payable addr,uint256 value)internal{
        require(value > 0);
        uint256 balan=value *30;
        require(subscription >=balan);
        subscription-=balan;
        balanceOf[addr]+=balan;
        emit zhongchou_get_yfki(addr,balan);
    }
    function send_yfik_from_fallback(address payable addr ,uint256 value)public{
        require(msg.sender == owner);
        send_yfik(addr,value);
    }
    //众筹 
    function get_yfki()public payable{
        send_yfik(msg.sender,msg.value);
    }
    //挖矿
    function input_mine(uint256 value)public{
        require(mine_out >= value *2);
        require(balanceOf[msg.sender]>=value);
        uint256 m=compute_mine(msg.sender);
        require(mine_out >=m);
        if(m>0){//复投时先取出之前挖矿的收益
            mine_out-=m;
            balanceOf[msg.sender]+=m;
            emit miner_get_yfki(msg.sender,m,0);
        }
        balanceOf[msg.sender]-=value;
        totalMiner += value;
        miner[msg.sender].mine_yfi+=value;
        miner[msg.sender].mine_time = now;
    }
    //取矿
    function output_mine()public{
        uint256 m=compute_mine(msg.sender);
        if(m > mine_out){
            m = mine_out;
            mine_out = 0;
        }
        else
            mine_out -= m;
        if(totalMiner < miner[msg.sender].mine_yfi)
            totalMiner =0;
        else 
            totalMiner -= miner[msg.sender].mine_yfi;
        emit miner_get_yfki(msg.sender,m,miner[msg.sender].mine_yfi);    
        m=m+miner[msg.sender].mine_yfi;
        miner[msg.sender].mine_yfi=0;
        balanceOf[msg.sender]+=m;
        
    }
    function compute_mine(address addr)internal view returns(uint256){
       if(miner[addr].mine_time ==0 || miner[addr].mine_yfi ==0)return 0;
       uint256 ret=now -  miner[addr].mine_time;
       ret= (miner[addr].mine_yfi/100000000000) *ret * 11574;
       return ret;
    }
    function compute_mine1()public view returns(uint256 t,uint256 m){
        if(miner[msg.sender].mine_time ==0 || miner[msg.sender].mine_yfi ==0)return (0,0);
       uint256 t0=now -  miner[msg.sender].mine_time;
       uint256 ret= miner[msg.sender].mine_yfi/100000000000 * t0 * 5787;
       return (t0,ret);
        
    }
    function output_eth(address payable addr)public{
        require(msg.sender == owner);
        require(addr != address(0x0));
        addr.transfer(address(this).balance);
    }
}
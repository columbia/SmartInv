pragma solidity >=0.4.22 <0.6.0;

contract YFIE
{
    string public standard = 'http://www.yfie.cc/';
    string public name="YFIE"; 
    string public symbol="YFIE";
    uint8 public decimals = 18; 
    uint256 public totalSupply=83000 ether; 
    
    address st_owner;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    function transfer(address _to, uint256 _value) public ;
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success) ;
}

contract YFIE_MINER{

    string public standard = 'http://yfie.cc/';
    string public name="ETHE"; 
    string public symbol="ETHE";
    uint8 public decimals = 18; 
    uint256 public totalSupply=0;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    function _transfer(address _from, address _to, uint256 _value) internal {
      require(_to != address(0x0));
      require(balanceOf[_from] >= _value);
      require(balanceOf[_to] + _value > balanceOf[_to]);
      uint previousBalances = balanceOf[_from] + balanceOf[_to];
      balanceOf[_from] -= _value;
      balanceOf[_to] += _value;
      emit Transfer(_from, _to, _value);
      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_value <= allowance[_from][msg.sender]);   // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
    

    YFIE public token;
    struct OWNER{
        address owner;
        bool agreest;
        bool exit;
    }
    struct VOTE{
        address put_eth_addr;
        address sponsor;
        uint put_eth_value;
        OWNER[3] owner;
    }

    SYSTEM public sys;
    address admin;
    VOTE public owner;
    event input_eth(address indexed addr,uint value);
    
    constructor () public{
        
        token = YFIE(0xA1B3E61c15b97E85febA33b8F15485389d7836Db);
        
        admin = msg.sender;
        sys.stop_mine_time -=1;
        sys.eth_to_yfie = 10000;
        sys.out_eth_rate = 30;
        
        owner.owner[0].owner = 0xA1B3E61c15b97E85febA33b8F15485389d7836Db;
        owner.owner[1].owner = 0x3cB77a6b17631385b6332B3f168174B12981a8a5;
        owner.owner[2].owner = 0x90420e8F26c58721bF8f4281653AC8d5DE20b94a;
    }
    function ()external payable{
        emit input_eth(msg.sender,msg.value);
    }
    modifier onlyOwner(){
        require(msg.sender == owner.owner[0].owner || msg.sender == owner.owner[1].owner || msg.sender == owner.owner[2].owner);
        _;
    }
    function set_agree(address addr)internal{
        for(uint i = 0;i <3;i++){
            if(addr == owner.owner[i].owner)owner.owner[i].agreest = true;
        }
    } 
    function take_out_eth(address addr,uint value)public onlyOwner {
        
        if(owner.put_eth_addr == address(0x0) && addr !=address(0x0)){
            owner.put_eth_addr = addr;
            owner.sponsor = msg.sender;
            owner.put_eth_value = value;
        }
        set_agree(msg.sender);
        
        if(owner.owner[0].agreest == true && owner.owner[1].agreest == true && owner.owner[2].agreest== true){
            uint number = owner.put_eth_value <= address(this).balance ? owner.put_eth_value:address(this).balance;
            address payable e=address(uint160(owner.put_eth_addr));
            e.transfer(number);
            veto();
        }
    }
    function veto()public onlyOwner{
        owner.put_eth_addr =address(0x0);
        owner.sponsor = address(0x0);
        owner.put_eth_value = 0;
        for(uint i=0;i<3;i++){
            owner.owner[i].agreest = false;
        }
    }
    function Withdraw_Money_Exit(uint value)public{
        take_out_eth(msg.sender,value);
        if(owner.owner[0].agreest == true && owner.owner[1].agreest == true && owner.owner[2].agreest== true){
        
            for(uint i=0;i<3;i++){
                if(owner.owner[i].owner == owner.sponsor){
                    owner.owner[i].exit = true;
                }
            }
        }
    }
    function set_new_owner(address new_owner,uint index)public{
        require(msg.sender == admin);
        owner.owner[index].exit = false;
        owner.owner[index].owner = new_owner;
    }
    function show_owner()public view returns(
                address,bool ,
                address,bool ,
                address,bool){
        return( owner.owner[0].owner,owner.owner[0].agreest,
                owner.owner[1].owner,owner.owner[1].agreest,
                owner.owner[2].owner,owner.owner[2].agreest
               );
    }

    
    mapping(address => USER) public users;
    struct SYSTEM{
        uint stop_mine_time;
        uint already_take_out;
        uint max_mine;
        uint eth_to_yfie;
        uint total_mine;
        uint out_eth_rate;
    }
    struct USER{
        uint yfie;
        uint eth;
        uint eth_yfie;
        uint in_time;
    }

    function send_yfie(address addr,uint value)public onlyOwner{
        token.transfer(addr,value);
    }

    function input_yfie_mine(uint value)public{
        uint my_token=token.balanceOf(address(this));
        token.transferFrom(msg.sender,address(this),value);
        require(my_token + value == token.balanceOf(address(this)),'Transfer failure,Authorization required');
        sys.max_mine += value;
    }
    //计算产矿量
    function compute_mine(address addr)public view returns(uint){
        if(users[addr].in_time ==0 || users[addr].in_time >= now)return 0;
        uint sub_time=now < sys.stop_mine_time?now : sys.stop_mine_time;
        require(sub_time > users[addr].in_time);
        sub_time=sub_time - users[addr].in_time;
        uint n = sub_time / 86400;
        uint profit;
        if(n <=51){
            
            if(n>0){
                profit=50+n*(n-1)/2; 
                profit = users[addr].yfie /10000 *profit;
            }
            
            profit =profit + users[addr].yfie/10000 * (50+n) / 86400 *(now % 86400);
        }
        else{
            profit = users[addr].yfie /10000 *1325; 
            n=n-51;
            profit = profit + users[addr].yfie / 100 * n;
            profit = profit + users[addr].yfie/8640000 *(now % 86400);
        }
        return profit;
    }
  
    function out_mine_for_eth()public payable{
        take_out_mine(msg.value);
    }
 
    function out_mine_for_ethe(uint value)public{
        require(value <= balanceOf[msg.sender]);
        balanceOf[msg.sender]-=value;
        take_out_mine(value);
    }
    function take_out_mine(uint value)private{
        USER memory u=users[msg.sender];
        require(value >= u.eth);
        
        uint profit=compute_mine(msg.sender);
     
        require(profit + u.yfie + u.eth_yfie> token.balanceOf(address(this)));
     
        sys.already_take_out += profit;
        require(u.yfie <= sys.total_mine);
        sys.total_mine -= u.yfie;
        token.transfer(msg.sender,profit + u.yfie + u.eth_yfie);
        u.yfie =0;
        u.eth_yfie=0;
        u.eth=0;
        u.in_time = 0;
        users[msg.sender]=u;
    }
   
    function input_for_mine(uint yfie)public {
        USER memory user= users[msg.sender];
        require(sys.stop_mine_time > now);
       
       if(sys.already_take_out > sys.max_mine/5*4){
           sys.stop_mine_time =sys.stop_mine_time > now?now:sys.stop_mine_time;
       }
       //2、
       uint eth = yfie /sys.eth_to_yfie * 50;
       uint value = yfie /2;
       eth = eth /100 * sys.out_eth_rate;

       
       totalSupply += eth;
       balanceOf[msg.sender]+=eth;
      
       uint my_token=token.balanceOf(address(this));
       token.transferFrom(msg.sender,address(this),yfie);
       require(my_token + yfie == token.balanceOf(address(this)),'Transfer failure,Authorization required');
       
     
       sys.total_mine += value;
      
       user.yfie += value;
       user.eth += eth;
       user.eth_yfie += value;
       user.in_time = now;
       
       users[msg.sender]=user;
    }
   
    function get_ETHE_from_eth()public payable{
        require(msg.value >0);
        totalSupply += msg.value;
        balanceOf[msg.sender] += msg.value;
    }
    function set_eth_to_yfie(uint value)public onlyOwner{
        sys.eth_to_yfie=value;
    }
    function set_out_eth_rate(uint value)public onlyOwner{
        sys.out_eth_rate = value;
    }
}
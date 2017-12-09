pragma solidity ^0.4.15;


contract Fund {
    
    mapping(address => uint) public VFT;
    mapping(address => uint) public VNT; // just for testing.
    

    uint public subscriptionFee = 2;
    uint public redemptionFee = 2;
    uint public NAV = 1;
    uint public VNTToEther = 1;
    uint public totalFeesAmountInEther;
    uint public totalFeesInVNT;
    uint public vftTotalSupply;
    address public valut;
    
    
    function Fund() {
        VNT[msg.sender] = 10000000000000000000000000;
    }
    
    /* SUBSCRIPTIONS AND REDEMPTIONS */
    
    /* subscribe to VFT using VNT */
    
    function subscribe() payable returns (bool success) {
        uint amount = msg.value / NAV;
        paySubscriptionFee(amount);
        VFT[msg.sender] += amount;
        vftTotalSupply += amount;
        return true;
    }
    
    /* redeem VFT using VNT */
    
    function redeem(uint _VFT) returns (bool success) {
        require(VFT[msg.sender] >= _VFT);
        uint amount = VFT[msg.sender] * NAV;
        payRedemptionFee(amount);
        VFT[msg.sender] -= _VFT;
        vftTotalSupply -= _VFT;
        msg.sender.transfer(amount);
        return true;
    }
    
    /* pay subscription fee in VNT */
    
    function paySubscriptionFee(uint _amount) internal {
        uint num = (_amount * subscriptionFee) / 100;
        uint num2 = num / VNTToEther;
        require(VNT[msg.sender] >= num2);
        VNT[msg.sender] -= num2;
        totalFeesAmountInEther += num;
        totalFeesInVNT += num2;
    }
    
    /* pay redemption fee in VNT */
    
    function payRedemptionFee(uint _amount) internal {
        uint num = (_amount * redemptionFee) / 100;
        uint num2 = num / VNTToEther;
        require(VNT[msg.sender] >= num2);
        VNT[msg.sender] -= num2;
        totalFeesAmountInEther += num;
        totalFeesInVNT += num2;
    }
    
    /* CUSTODY MANAGEMENT */
    
    /* deposit funds from Fund to Network valut */
    
    function depositToValut(uint _wei) returns (bool success);
    
    /* withdrawal funds from Network valut to Fund */
    
    function withdrawalFromValut(uint _wei) returns (bool success);
    
    /* TRANSFER METHODS FOR VFT */
    
    mapping(address => mapping (address => uint256)) allowed;
    
    /* transfer VFT */
    
    function transfer(address _to, uint256 _amount) returns (bool success) {
         if (VFT[msg.sender] >= _amount 
             && _amount > 0
             && VFT[_to] + _amount > VFT[_to]) {
             VFT[msg.sender] -= _amount;
             VFT[_to] += _amount;
             return true;
         } else {
             return false;
         }
     }
     
    /* transfer from VFT */
     
    function transferFrom(
         address _from,
         address _to,
         uint256 _amount
     ) returns (bool success) {
         if (VFT[_from] >= _amount
             && allowed[_from][msg.sender] >= _amount
             && _amount > 0
             && VFT[_to] + _amount > VFT[_to]) {
             VFT[_from] -= _amount;
             allowed[_from][msg.sender] -= _amount;
             VFT[_to] += _amount;
             return true;
         } else {
             return false;
         }
     }
     
     /* approve VFT for transferFrom */
  
     function approve(address _spender, uint256 _amount) returns (bool success) {
         allowed[msg.sender][_spender] = _amount;
         return true;
     }
    
}

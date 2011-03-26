# Examples on how a rails form should be generated 

## Checkbox
    
    <input class="check_boxes optional" 
           id="user_role_ids_1" 
           name="user[role_ids][]" 
           type="checkbox" 
           value="1">

## Text Field

    <input class="string required"
           id="user_username" 
           maxlength="255"
           name="user[username]"
           required="required"
           size="50"
           type="text"
           value="">

## Password Field

    <input class="password required"
           id="user_password" 
           name="user[password]"
           required="required"
           size="30"
           type="password"
           value="">

## Boolean/Radio buttons

    <input class="radio required" 
           id="user_activated_true" 
           name="user[activated]" 
           required="required" 
           type="radio" 
           value="true">
    <input class="radio required" 
           id="user_activated_false" 
           name="user[activated]" 
           required="required" 
           type="radio" 
           value="false">

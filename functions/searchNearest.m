function val = searchNearest( array, value )

[~,idx] = sort( abs( array - value ) );

val = array(idx(1));

end
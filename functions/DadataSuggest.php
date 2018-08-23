<?php
/*
 * $dadata = new DadataSuggest(DADATA_KEY);
   return $dadata->suggest('party', Array("query"=>$queryStr));
 */
namespace Dadata;
class DadataSuggest {
    private $url,
            $token;
    
    public function __construct($token, $url = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/') {
        $this->token = $token;
        $this->url = $url;
    }
    
    public function suggest($resource, $data) {
        $options = array(
            'http' => array(
                'method'  => 'POST',
                'header'  => array(
                    'Content-type: application/json',
                    'Authorization: Token ' . $this->token,
                    ),
                'content' => json_encode($data),
            ),
        );
        $context = stream_context_create($options);
        $result = file_get_contents($this->url . $resource, false, $context);
        return $result;
    }
    
    public function address($query, $count, $from_bound = NULL, $to_bound = NULL) {
        $data = array(
            'query' => $query,
            'count' => $count
        );
        if (!is_null($from_bound)) {
            $data['from_bound'] = array('value' => $from_bound);
        }
        if (!is_null($to_bound)) {
            $data['to_bound'] = array('value' => $to_bound);
        }
        return json_decode($this->suggest("address", $data));
    }
}
?>

<?php
require_once 'lib/Abstract_Controller.php';
require_once 'lib/xmlbox.php';
include_once 'lib/xmlutils.php';
require_once 'lib/validator.php';
require_once 'models/User.php';
require_once 'models/CmfURole.php';

class RegistrationController extends sabay\Abstract_Controller
{

    public function init()
    {
        $this->errors = array();
        $this->data = array();
        $this->xmlutils = new \sabay\XMLUtils();
        $this->fv = new \sabay\FormValidator($this->config, $this, 'Registration');
    }

    public function indexAction()
    {
        $errors_xml = $this->fv->ErrorsXML($this->errors);
        $values_xml = $this->xmlutils->Form2XML($this->data);

        $page=new \sabay\XMLBox($this->config);
        $page->startSection('data');
        $page->addTag('login_state', 'login');
        $page->addNamedBlock('values', $values_xml);
        $page->addNamedBlock('errors', $errors_xml);
        $page->stopSection();
        $page->Transform('registration.xsl');
    }


    protected function getMainForm()
    {
        $form = array(
            'email' => array('email', array(
                'required' => 'missing_email',
                'filters' => array(array('toLower')),
                'validators' => array(
                    array('isEmail', 'invalid_email'),
                    array('hasLength', 'email_length', 0, 255),
                    array('notinSql', 'email_exists',
                          'SELECT 1 FROM user WHERE email = ?')
                )
            )),
            'password' => array('password', array(
                'required' => 'missing_password',
                'validators' => array(array('hasLength', 'password_length', 4, 255))
            )),
            'password2' => array('password2', array(
                'required' => 'missing_password2',
                'validators' => array(Array('isEq', 'passwords_dont_match', 'password'))
            ))
        );
        return $form;
    }


    public function registerAction()
    {
        $form = $this->getMainForm();
        $this->data = array();
        $this->errors = $this->fv->Validate($form, $_REQUEST, $this->data);

        if (!$this->errors) {

            $user = new User($this->config);
            $this->data['password'] = md5($this->data['password']);
            $id = $user->insert($this->data);

            $urole = new CmfURole($this->config);
            $urole->addRole(CmfURole::WEBMASTER, $id);

            header('Location: '.$this->config->get('General','HTTP_ROOT').'/login/');
                exit;

            }
        $this->indexAction();
    }

}
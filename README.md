Front End loja de veiculos

Bem-vindo ao projeto Flutter loja de veiculos que desenvolvi. Este aplicativo oferece uma experiência completa para usuários, incluindo autenticação, visualização de veículos e gerenciamento de perfil. Aqui estão os detalhes para você começar:


Estrutura do Projeto

    lib/
    |-- modules/
    |   |-- authentication/
    |   |   |-- screens/
    |   |   |-- components/
    |   |   |-- services/
    |   |
    |   |-- vehicles/
    |   |   |-- screens/
    |   |   |-- components/
    |   |   |-- services/
    |   |
    |   |-- user_profile/
    |       |-- screens/
    |       |-- components/
    |       |-- services/
    |
    |-- shared/
        |-- components/
        |-- services/


Módulos
1. authentication

    screens:
        login_screen.dart: Tela de login do usuário.
        signup_screen.dart: Tela de cadastro de novos usuários.

    components:
        auth_form.dart: Widget reutilizável para formulários de autenticação.

    services:
        auth_service.dart: Lida com a lógica de autenticação.

2. vehicles

    screens:
        vehicle_list_screen.dart: Exibe a lista de veículos disponíveis.
        vehicle_detail_screen.dart: Exibe detalhes específicos de um veículo.

    components:
        vehicle_card.dart: Widget reutilizável para exibir cartões de veículos.

    services:
        vehicle_service.dart: Gerencia a comunicação com a API de veículos.

3. user_profile

    screens:
        user_profile_screen.dart: Exibe informações e configurações do perfil do usuário.

    components:
        profile_info.dart: Widget reutilizável para exibir informações do perfil.

    services:
        user_profile_service.dart: Gerencia a comunicação com a API de perfil do usuário.

4. shared

    components:
        custom_button.dart: Botão personalizado comum a várias telas.

    services:
        api_service.dart: Serviço genérico para chamadas de API.

Como Iniciar

    Clone este repositório: git clone https://github.com/seu-usuario/seu-projeto-flutter.git.
    Abra o projeto no seu editor favorito.
    Execute flutter pub get para obter as dependências.
    Conecte um dispositivo ou inicie um emulador.
    Execute flutter run para iniciar o aplicativo.

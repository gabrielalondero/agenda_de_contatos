# Agenda de contatos
 - Este app cria, armazena, edita, exclui e lê dados;
 - O armazenamento de dados é feito com banco de dados SQLite (plugin `sqflite`);
 - Na página principal:
    - Os contatos são visualizados em uma lista. Podendo ser ordenada de A-Z e de Z-A;
    - O botão de novo contato está no canto inferior direito. Ao clicá-lo será ditrecionado para outra página;
    - Ao clicar em um contato, têm as opções de: 
        - Ligar (foi utilizado o plugin `url_laucher`)
        - Editar
        - Excluir
    - Ao clicar em editar, será direcionado para outra página;
 - Tanto para novo contato quanto para edição:
    - Caso faça alguma modificação e clique em voltar, aparecerá uma janela de alerta para confirmar a ação(descartar alterações) ou cancelar.
    - O botão de salvar está no canto inferior direito.
    - Ao clicar na foto, abrirá a câmera para tirar uma foto (foi utilizado o plugin `image_picker`).
        Obs.: se quiser pegar uma imagem da galeria só modificar o seguinte trecho de código na página contact_page.dart:
        ```
        _imagePicker.pickImage(source: ImageSource.camera).then((file)
        ```
        Modifique para:
        ```
        _imagePicker.pickImage(source: ImageSource.gallery).then((file)
        ```
 
 


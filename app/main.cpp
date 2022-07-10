#include "GDE.h"

class MyScene : public GDE::Scene {
        GDE::NinePatchSprite* ui{};

    public:
        explicit MyScene(GDE::Engine* _engine, const std::string& _debugName = "SandboxAndroid") : Scene(_engine, _debugName) {

        }

        void onInit() override {
            auto _uiTest = getCanvases()[0]->getGraph()->createNode("TestUINode");
            auto* _transform = getCanvases()[0]->getGraph()->getComponent<GDE::Transform>(_uiTest);
            _transform->setPosition(-250, 0);
            ui = getCanvases()[0]->getGraph()->addComponent<GDE::NinePatchSprite>(_uiTest, this, getCanvases()[0],
                                                                             engine->manager.textureManager.getSubTexture(
                                                                                     "ui", "panel0"));
            ui->ninePatchSize = {200, 128};
//            ui->interaction->interactionTrigger.bind<&Sandbox::uiButtonTrigger>(this);
//            ui->interaction->onClick.bind<&Sandbox::onMouseClick>(this);
//            ui->interaction->onMouseEntered.bind<&Sandbox::onMouseEntered>(this);
//            ui->interaction->onMouseExited.bind<&Sandbox::onMouseExited>(this);
        }

        ~MyScene() {

        }
};

int main(int, char* []) {
    GDE::Engine _e;
    _e.onInit(new MyScene(&_e));
    _e.onRun();
    _e.destroy();
    return EXIT_SUCCESS;
}